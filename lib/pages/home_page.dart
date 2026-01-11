import 'package:flutter/material.dart';
import 'package:is_mc_fk_running/l10n/app_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:is_mc_fk_running/data/database.dart';
import 'dart:ui';

import '../widget/server_card.dart';
import '../widget/add_server_dialog.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with AutomaticKeepAliveClientMixin<Homepage> {
  final _serverListBox = Hive.box('serverListBox');
  ServerListDataBase db = ServerListDataBase(); // 引入数据

  @override
  bool get wantKeepAlive => true; // 保持页面状态

  @override
  void initState() {
    if (_serverListBox.get("ITEMS") == null) {
      // 第一次打开显示欢迎页面 引导用户输入内容
    } else {
      db.loadData();
    }
    super.initState();
  }

  void _addItem(Map<String, String> item) {
    setState(() {
      db.items.add(item);
    });
    db.updateDataBase();
  }

  void _removeItem(int index) {
    setState(() {
      db.items.removeAt(index);
    });
    db.updateDataBase();
  }

  void _updateItem(int index, Map<String, String> newItem) {
    setState(() {
      db.items[index] = newItem;
    });
    db.updateDataBase();
  }

  /// 弹出输入框
  Future<void> _showAddDialog() async {
    final result = await showAddServerDialog(context);
    if (result != null) {
      _addItem({...result});
    }
  }

  /// 弹出编辑框
  Future<void> _showEditDialog(int index, Map<String, dynamic> item) async {
    final result = await showAddServerDialog(context, initialValue: item);
    if (result != null) {
      if (result['delete'] == true) {
        _removeItem(index);
      } else {
        _updateItem(index, {...item, ...result});
      }
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      db.loadData();
    });
    // Trigger refresh on all ServerCard children via some mechanism or just rebuild
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              centerTitle: true,
              elevation: 0,
              title: Text(
                l10n.servers,
                style: TextStyle(
                  fontFamily: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.fontFamily,
                  fontWeight: FontWeight.w900, // Extra bold for readability
                  fontSize: 26,
                  color: colorScheme
                      .onSurface, // Use onSurface for better contrast
                  letterSpacing: 1.5,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: _handleRefresh,
                  icon: const Icon(Icons.refresh_rounded, size: 24),
                  tooltip: l10n
                      .refresh, // Make sure to add this in l10n if not exists
                ),
                const SizedBox(width: 8),
              ],
              backgroundColor: colorScheme.surface.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.surface,
                  colorScheme.primaryContainer.withValues(alpha: 0.1),
                  colorScheme.surface,
                ],
              ),
            ),
          ),
          // Subtle Pattern or shapes
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.05),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                80,
              ), // Enough to see items under the bar
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 500,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1.4,
              ),
              itemCount: db.items.length,
              itemBuilder: (context, index) {
                return ServerCard(
                  item: db.items[index],
                  onEdit: () => _showEditDialog(index, db.items[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: FloatingActionButton.extended(
                backgroundColor: colorScheme.primary.withValues(alpha: 0.7),
                elevation: 0,
                focusElevation: 0,
                hoverElevation: 0,
                highlightElevation: 0,
                onPressed: _showAddDialog,
                icon: const Icon(
                  Icons.add_rounded,
                  size: 24,
                  color: Colors.white,
                ),
                label: Text(
                  l10n.addServer,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
