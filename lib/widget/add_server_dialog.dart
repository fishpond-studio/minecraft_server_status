import 'package:flutter/material.dart';

Future<Map<String, String>?> showAddServerDialog(BuildContext context) {
  String inputName = "";
  String inputAddress = "";
  String inputPort = "";
  return showDialog<Map<String, String>>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("添加新服务器"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "名称(Sever)",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                inputName = value;
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: "地址",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                inputAddress = value;
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: "端口(25565)",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                inputPort = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null), // 取消
            child: const Text("取消"),
          ),
          ElevatedButton(
            onPressed: () {
              if (inputName.trim().isEmpty) {
                inputName = "Sever";
              }
              if (inputPort.trim().isEmpty) {
                inputPort = "25565";
              }
              if (inputAddress.trim().isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("请输入地址")));
              }
              if (inputAddress.trim().isNotEmpty) {
                Navigator.pop(context, {
                  'name': inputName.trim(),
                  'address': inputAddress.trim(),
                  'port': inputPort.trim(),
                });
              }
            },
            child: const Text("添加"),
          ),
        ],
      );
    },
  );
}
