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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6), //低明度
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              //服务器版本
              Container(child: Text('version')),

              //服务器介绍
              Container(child: Text('description')),

              //服务器人数(进度条)
              Container(child: Text('players')),
            ],
          ),
        ),
      ),
    );
  }
}
