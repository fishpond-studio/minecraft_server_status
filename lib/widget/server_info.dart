import 'package:flutter/material.dart';
import 'package:is_mc_fk_running/services/minecraft_server_status.dart';

class ServerInfo extends StatefulWidget {
  final String host;
  final String port;

  const ServerInfo({super.key, required this.host, required this.port});

  @override
  State<ServerInfo> createState() => _ServerInfoState();
}

class _ServerInfoState extends State<ServerInfo> {
  late MinecraftServerStatus server;
  Map? info;

  @override
  void initState() {
    super.initState();
    server = MinecraftServerStatus(
      host: widget.host,
      port: int.parse(widget.port),
    );
    _loadServerInfo();
  }

  Future<void> _loadServerInfo() async {
    try {
      info = await server.getServerStatus();
    } catch (e) {
      info = {'online': false, 'error': e.toString()};
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        children: [Text(info.toString(), style: TextStyle(fontSize: 9))],
      ),
    );
  }
}
