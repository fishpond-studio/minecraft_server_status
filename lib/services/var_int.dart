/// VarInt 编解码工具类
/// 用于 Minecraft 协议中的可变长度整数编解码
class VarInt {
  /// VarInt 固定位标志（最高位为1表示还有后续字节）
  static const int varintFix = 0x80;

  /// 将整数编码为 VarInt 字节列表
  /// [value] 要编码的整数值
  /// 返回编码后的字节列表
  static List<int> encode(int value) {
    // 首先确保它被当作32位有符号整数处理
    value = value.toSigned(32);

    final bytes = <int>[];

    // 使用无符号表示进行位操作
    int uValue = value & 0xFFFFFFFF;

    // 每次取7位，如果还有剩余则设置最高位为1
    while (uValue >= 0x80) {
      bytes.add((uValue & 0x7F) | 0x80);
      uValue >>>= 7; // 使用逻辑右移
    }

    // 最后一个字节的最高位为0
    bytes.add(uValue & 0x7F);
    return bytes;
  }

  /// 将 VarInt 字节列表解码为整数
  /// [data] 要解码的字节列表
  /// 返回解码后的整数值
  static int decode(List<int> data) {
    int result = 0;
    int offset = 0;

    for (int i = 0; i < data.length; i++) {
      final byte = data[i];

      // 取低7位并左移到正确位置
      result |= (byte & 0x7F) << offset;

      // 如果最高位为0，表示这是最后一个字节
      if ((byte & varintFix) == 0) {
        // 检查结果是否在32位有符号整数范围内
        if (result < -2147483648 || result > 2147483647) {
          throw Exception('VarInt 超出32位有符号整数范围');
        }
        return result;
      }
      offset += 7;
    }
    throw Exception('VarInt 不完整');
  }

  /// 获取 VarInt 的字节长度
  /// [data] 包含 VarInt 的字节列表
  /// [index] 起始索引位置
  /// 返回 VarInt 占用的字节数
  static int getVarIntLength(List<int> data, {int index = 0}) {
    // VarInt 最多5个字节
    const maxVarIntBytes = 5;
    for (var i = 0; i < maxVarIntBytes && index + i < data.length; i++) {
      // 如果最高位为0，返回当前长度
      if ((data[index + i] & 0x80) == 0) return i + 1;
    }
    throw ArgumentError('VarInt 太长或不完整');
  }
}
