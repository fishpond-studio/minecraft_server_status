import 'minecraft_server_status.dart';

void main() async {
  var server = MinecraftServerStatus(host: 'mc.hypixel.net', port: 25565);
  print(await server.getServerStatus());
}
