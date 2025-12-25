import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class _VarInt {
  static const int varintFix = 0x80;

  static List<int> encode(int value) {
    assert(
      value >= -2147483648 && value <= 2147483647,
      'Value must be a 32-bit signed integer',
    );

    final bytes = <int>[];

    while (value >= varintFix) {
      bytes.add((value & 0x7F) | varintFix);
      value >>= 7;
    }

    bytes.add(value & 0x7F);
    return bytes;
  }

  static int decode(List<int> data) {
    int result = 0;
    int offset = 0;

    for (int i = 0; i < data.length; i++) {
      final byte = data[i];

      result |= (byte & 0x7F) << offset;

      if ((byte & varintFix) == 0) {
        if (result < -2147483648 || result > 2147483647) {
          throw Exception('VarInt out of 32-bit signed integer range');
        }
        return result;
      }
      offset += 7;
    }
    throw Exception('Incomplete VarInt');
  }

  static int getVarIntLength(List<int> data, {int index = 0}) {
    const maxVarIntBytes = 5;
    for (var i = 0; i < maxVarIntBytes && index + i < data.length; i++) {
      if ((data[index + i] & 0x80) == 0) return i + 1;
    }
    throw ArgumentError('VarInt is too long or incomplete.');
  }
}

class MinecraftServerStatus {
  final String host;
  final int port;

  MinecraftServerStatus({required this.host, this.port = 25565}) {
    if (host.isEmpty) {
      throw ArgumentError.value(host, 'host', 'host cannot be empty.');
    }
    if (host.codeUnits.length > 255) {
      throw ArgumentError.value(host, 'host', 'host is too long.');
    }
    if (port < 1 || port > 65535) {
      throw ArgumentError.value(port, 'port', 'port must between 1 to 65535');
    }
  }

  List<int> _getHostBytes(String host) => [
    ..._VarInt.encode(ascii.encode(host).length),
    ...ascii.encode(host),
  ];

  List<int> _getPortBytes(int port) => [(port >> 8) & 0xFF, port & 0xFF];

  List<int> _getHandshakePacket({int protocolVersion = -1}) => [
    0,
    ..._VarInt.encode(protocolVersion),
    ..._getHostBytes(host),
    ..._getPortBytes(port),
    1,
  ];

  Future<List<int>> _socketConnect() async {
    // 建立连接
    Socket socket = await Socket.connect(host, port);

    // 发送handskake包
    List<int> handshakePacket = _getHandshakePacket();
    socket.add(
      Uint8List.fromList([
        ..._VarInt.encode(handshakePacket.length),
        ...handshakePacket,
      ]),
    );

    // 发送请求
    socket.add(Uint8List.fromList([0x01, 0x00]));

    // 接收
    final completer = Completer<List<int>>();
    final buffer = <int>[];

    socket.listen(
      (Uint8List data) {
        buffer.addAll(data);

        if (buffer.length > 0) {
          // 解析 VarInt 长度
          int offset = 0; // 如果有多个包，这里可能需要累计
          int packetLengthLength = _VarInt.getVarIntLength(
            buffer,
            index: offset,
          );
          if (buffer.length >= offset + packetLengthLength) {
            int packetLength = _VarInt.decode(
              buffer.sublist(offset, offset + packetLengthLength),
            );

            // 判断包体是否接收完整
            if (buffer.length >= offset + packetLengthLength + packetLength) {
              List<int> fullPacket = buffer.sublist(
                offset + packetLengthLength,
                offset + packetLengthLength + packetLength,
              );
              completer.complete(fullPacket);
              socket.destroy();
            }
          }
        }
      },
      onError: (e) {
        if (!completer.isCompleted) completer.completeError(e);
      },
      onDone: () {
        if (!completer.isCompleted) completer.complete(buffer);
      },
    );

    return completer.future;
  }

  Future<Map<String, dynamic>> getServerStatus() async {
    List<int> received = await _socketConnect();
    int offset = 0;
    int packetID = received[offset];
    if (packetID != 0) {
      throw Exception('Unexpected packetID: $packetID');
    }
    offset += 1;
    int jsonLengthLength = _VarInt.getVarIntLength(received, index: offset);
    int jsonLength = _VarInt.decode(
      received.sublist(offset, offset + jsonLengthLength),
    );
    offset += jsonLengthLength;
    if (received.length < offset + jsonLength) {
      throw Exception('Incomplete JSON data');
    }
    List<int> jsonData = received.sublist(offset, offset + jsonLength);
    String jsonString = utf8.decode(jsonData);
    return jsonDecode(jsonString);
  }
}
