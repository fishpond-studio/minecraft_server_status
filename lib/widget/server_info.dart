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
        children: [
          //图标&服务器名称
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  //图标
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: 25,
                      decoration: BoxDecoration(color: Colors.red),
                      child: Center(child: Icon(Icons.abc)),
                    ),
                  ),

                  //服务器IP
                  Expanded(
                    flex: 5,
                    child: FittedBox(
                      alignment: Alignment.center,
                      fit: BoxFit.fitWidth,
                      child: Container(
                        //内边距
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          '${widget.host}:${widget.port}',
                          overflow: TextOverflow.visible,
                          softWrap: false,
                          style: TextStyle(fontSize: 200),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //分割线
          Divider(
            color: Colors.grey[800],
            thickness: 0.3,
            height: 0.3, //消除空隙
            indent: 16,
            endIndent: 16,
          ),

          //服务器版本
          Expanded(
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  info?['version'] ?? 'N/A',
                  overflow: TextOverflow.visible,
                  softWrap: false,
                  style: TextStyle(fontSize: 200),
                ),
              ),
            ),
          ),

          //world name
          Expanded(
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  info?['world_name'] ?? 'N/A',
                  overflow: TextOverflow.visible,
                  softWrap: false,
                  style: TextStyle(fontSize: 200),
                ),
              ),
            ),
          ),

          //服务器信息更新最后时间
          Expanded(child: Container()),

          //服务器客户端类型
          Expanded(child: Container()),

          //服务器延迟
          Expanded(child: Container()),

          //服务器人数(进度条)
          Expanded(child: Container()),

          //服务器占用(进度条)
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
