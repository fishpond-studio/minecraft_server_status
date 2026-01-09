import 'package:flutter/material.dart';

Future<Map<String, String>?> showEditServerDialog(
  BuildContext context,
  Map<String, String> item,
) {
  final initialName = item['name'] ?? '';
  final initialAddress = item['address'] ?? '';
  final initialPort = item['port'] ?? '';

  final nameController = TextEditingController(text: initialName);
  final addressController = TextEditingController(text: initialAddress);
  final portController = TextEditingController(text: initialPort);

  return showDialog<Map<String, String>>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("编辑服务器", style: TextStyle()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "名称",
                border: OutlineInputBorder(),
              ),
              controller: nameController,
            ),
            const SizedBox(height: 16),
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "地址",
                border: OutlineInputBorder(),
              ),
              controller: addressController,
            ),
            const SizedBox(height: 16),
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "端口",
                border: OutlineInputBorder(),
              ),
              controller: portController,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null), // 取消
            child: const Text("取消", style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim().isEmpty
                  ? initialName
                  : nameController.text.trim();
              final address = addressController.text.trim().isEmpty
                  ? initialAddress
                  : addressController.text.trim();
              final portStr = portController.text.trim().isEmpty
                  ? initialPort
                  : portController.text.trim();
              final port = int.tryParse(portStr);

              if (address.isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('请输入地址')));
                return;
              }

              if (port == null || port < 1 || port > 65535) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('端口号必须为1-65535之间的数字')),
                );
                return;
              }

              Navigator.pop<Map<String, String>>(context, {
                'name': name,
                'address': address,
                'port': port.toString(),
              });
            },

            child: const Text("保存", style: TextStyle(color: Colors.black)),
          ),
        ],
      );
    },
  );
}
