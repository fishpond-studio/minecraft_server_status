import 'package:flutter/material.dart';
import 'package:is_mc_fk_running/l10n/app_localizations.dart';

Future<Map<String, dynamic>?> showAddServerDialog(
  BuildContext context, {
  Map<String, dynamic>? initialValue,
}) {
  String inputName = initialValue?['name'] ?? "";
  String inputAddress = initialValue?['address'] ?? "";
  String inputPort = initialValue?['port']?.toString() ?? "";
  final isEditing = initialValue != null;

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context)!;
      final theme = Theme.of(context);
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          isEditing ? l10n.editServerTitle : l10n.addServerTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: inputName,
              autofocus: !isEditing,
              decoration: InputDecoration(
                labelText: '${l10n.nameLabel}(Server)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.label_outline),
              ),
              onChanged: (value) {
                inputName = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: inputAddress,
              decoration: InputDecoration(
                labelText: l10n.addressLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.dns),
              ),
              onChanged: (value) {
                inputAddress = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: inputPort,
              decoration: InputDecoration(
                labelText: l10n.portLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.numbers),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                inputPort = value;
              },
            ),
          ],
        ),
        actions: [
          if (isEditing)
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(l10n.delete),
                      content: Text(l10n.confirmDeleteServer(inputName)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.cancel),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // 关闭确认对话框
                            Navigator.pop(context, {
                              'delete': true,
                            }); // 关闭编辑对话框并传递删除操作
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[300]?.withValues(
                              alpha: 0.9,
                            ),
                          ),
                          child: Text(
                            l10n.delete,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              label: Text(
                l10n.delete,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context, null), // 取消
            child: Text(
              l10n.cancel,
              style: TextStyle(color: theme.colorScheme.secondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              final name = inputName.trim().isEmpty
                  ? l10n.defaultServerName
                  : inputName.trim();
              final address = inputAddress.trim();
              final portStr = inputPort.trim().isEmpty
                  ? '25565'
                  : inputPort.trim();
              final port = int.tryParse(portStr);

              if (address.isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.enterAddress)));
                return;
              }

              if (port == null || port < 1 || port > 65535) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.invalidPort)));
                return;
              }

              Navigator.pop(context, {
                'name': name,
                'address': address,
                'port': port.toString(),
              });
            },

            child: Text(
              isEditing ? l10n.save : l10n.add,
              style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
            ),
          ),
        ],
      );
    },
  );
}
