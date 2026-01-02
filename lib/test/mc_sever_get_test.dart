import 'dart:io';

import '../services/minecraft_server_status.dart';

void main() async {
  stdout.write('server host: ');
  final hostInput = stdin.readLineSync();

  if (hostInput == null || hostInput.trim().isEmpty) {
    stderr.writeln('host can not be empty');
    exit(1);
  }

  // 输入 port
  stdout.write('server port (press Enter for 25565): ');
  final portInput = stdin.readLineSync();

  // 端口处理：默认 25565
  final int port = (portInput == null || portInput.trim().isEmpty)
      ? 25565
      : int.tryParse(portInput) ?? 25565;

  // 创建服务对象
  final server = MinecraftServerStatus(host: hostInput.trim(), port: port);

  try {
    final status = await server.getServerStatus();
    print(status);
  } catch (e, stack) {
    stderr.writeln(e);
    stderr.writeln(stack);
  }
}
