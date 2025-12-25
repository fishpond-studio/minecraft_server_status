import 'minecraft_server_status.dart';

// for test
void main() async {
  var server = MinecraftServerStatus(host: '192.168.0.107', port: 64519);
  print(await server.getServerStatus());
}
