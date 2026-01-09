import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:is_mc_fk_running/services/minecraft_server_status.dart';
import 'package:is_mc_fk_running/widget/server_info_controller.dart';

class ServerInfo extends StatefulWidget {
  final String host;
  final String port;
  final ServerInfoController controller;

  const ServerInfo({
    super.key,
    required this.host,
    required this.port,
    required this.controller,
  });

  @override
  State<ServerInfo> createState() => ServerInfoState();
}

class ServerInfoState extends State<ServerInfo> {
  late MinecraftServerStatus server;
  Map? info;

  @override
  void initState() {
    super.initState();
    _initServer();
    widget.controller.refresh = loadServerInfo;
  }

  void _initServer() {
    server = MinecraftServerStatus(
      host: widget.host,
      port: int.parse(widget.port),
    );
    loadServerInfo();
  }

  @override
  void didUpdateWidget(covariant ServerInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.host != widget.host || oldWidget.port != widget.port) {
      _initServer();
    }
  }

  @override
  void dispose() {
    widget.controller.refresh = null;
    super.dispose();
  }

  Future<void> loadServerInfo() async {
    try {
      final data = await server.getServerStatus();
      if (!mounted) return;
      setState(() => info = data);
    } catch (e) {
      if (!mounted) return;
      setState(() => info = {'online': false, 'error': e.toString()});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1️⃣ 背景图（不透明，供模糊）
            if (info?["favicon"] != null)
              Image.memory(
                base64Decode(info!["favicon"].split(',').last),
                fit: BoxFit.cover,
              ),

            // 2️⃣ 模糊层（只模糊背景）
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.white.withValues(alpha: 0.3), // 磨砂遮罩
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  //服务器版本
                  Container(child: Text('${info?['version']?['name']}')),

                  //服务器介绍
                  Container(child: Text('${info?['description']}')),

                  //服务器人数(进度条)
                  Container(child: Text('players')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
