import 'package:flutter/material.dart';
import 'package:is_mc_fk_running/l10n/app_localizations.dart';
import 'package:is_mc_fk_running/pages/sponsor_page.dart';
import 'package:is_mc_fk_running/services/test_data_generator.dart';
import 'package:is_mc_fk_running/data/database.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../theme/theme_provider.dart';
import 'about_page.dart';

class PictureChange extends StatefulWidget {
  const PictureChange({super.key});

  @override
  State<PictureChange> createState() => _PictureChangeState();
}

class _PictureChangeState extends State<PictureChange> {
  late Box _settingsBox;
  bool _developerMode = false;

  @override
  void initState() {
    super.initState();
    _settingsBox = Hive.box('serverListBox');
    _loadDeveloperMode();
  }

  void _loadDeveloperMode() {
    setState(() {
      _developerMode = _settingsBox.get('developerMode', defaultValue: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

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
                l10n.settings,
                style: TextStyle(
                  fontFamily: theme.textTheme.bodyMedium?.fontFamily,
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                //自定义设置部分
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.surface.withValues(alpha: 0.8),
                        theme.colorScheme.surface.withValues(alpha: 0.5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withValues(alpha: 0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //日间/夜晚模式
                        _buildSettingItem(
                          context,
                          icon: Icons.brightness_6,
                          label: l10n.dayNightMode,
                          trailing: Transform.scale(
                            scale: 0.8,
                            child: Consumer<ThemeProvider>(
                              builder: (context, themeProvider, child) {
                                return Switch(
                                  value: themeProvider.isDarkMode,
                                  onChanged: (value) {
                                    themeProvider.toggleThemeMode(value);
                                  },
                                );
                              },
                            ),
                          ),
                        ),

                        _buildDivider(context),

                        //更换主题颜色
                        _buildSettingItem(
                          context,
                          icon: Icons.color_lens,
                          label: l10n.changeThemeColor,
                          trailing: Transform.scale(
                            scale: 0.9,
                            child: Consumer<ThemeProvider>(
                              builder: (context, themeProvider, child) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: themeProvider.currentColorName,
                                    onChanged: (value) {
                                      if (value != null) {
                                        themeProvider.changeThemeColor(value);
                                      }
                                    },
                                    items: themeProvider.availableColors
                                        .map<DropdownMenuItem<String>>((
                                          String value,
                                        ) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        })
                                        .toList(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        _buildDivider(context),

                        // Language
                        _buildSettingItem(
                          context,
                          icon: Icons.language,
                          label: l10n.language,
                          trailing: Transform.scale(
                            scale: 0.9,
                            child: Consumer<ThemeProvider>(
                              builder: (context, themeProvider, child) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: themeProvider.currentLocaleTag,
                                    onChanged: (value) {
                                      if (value != null) {
                                        themeProvider.changeLocaleTag(value);
                                      }
                                    },
                                    items: [
                                      DropdownMenuItem(
                                        value: 'system',
                                        child: Text(l10n.languageSystem),
                                      ),
                                      DropdownMenuItem(
                                        value: 'zh',
                                        child: Text(l10n.languageChinese),
                                      ),
                                      DropdownMenuItem(
                                        value: 'en',
                                        child: Text(l10n.languageEnglish),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        _buildDivider(context),

                        //更换字体
                        _buildSettingItem(
                          context,
                          icon: Icons.font_download,
                          label: l10n.changeFont,
                          trailing: Transform.scale(
                            scale: 0.9,
                            child: Consumer<ThemeProvider>(
                              builder: (context, themeProvider, child) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: themeProvider.currentFontFamily,
                                    onChanged: (value) {
                                      if (value != null) {
                                        themeProvider.changeFontFamily(value);
                                      }
                                    },
                                    items: themeProvider.availableFonts
                                        .map<DropdownMenuItem<String>>((
                                          String value,
                                        ) {
                                          String label;
                                          switch (value) {
                                            case 'System':
                                              label = l10n.fontSystem;
                                              break;
                                            case 'FMinecraft':
                                              label = l10n.fontMinecraft;
                                              break;
                                            case 'FJetBrainsMono':
                                              label = l10n.fontJetBrainsMono;
                                              break;
                                            default:
                                              label = value;
                                          }
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(label),
                                          );
                                        })
                                        .toList(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        _buildDivider(context),

                        // 更新时间间隔设置
                        _buildSettingItem(
                          context,
                          icon: Icons.update,
                          label: l10n.updateTime,
                          trailing: Transform.scale(
                            scale: 0.9,
                            child: Consumer<ThemeProvider>(
                              builder: (context, themeProvider, child) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    value: themeProvider.updateInterval,
                                    onChanged: (value) {
                                      if (value != null) {
                                        // 更新状态栏刷新间隔
                                        themeProvider.changeUpdateInterval(
                                          value,
                                        );
                                      }
                                    },
                                    items: [
                                      const DropdownMenuItem(
                                        value: 10,
                                        child: Text('10s'),
                                      ),
                                      const DropdownMenuItem(
                                        value: 30,
                                        child: Text('30s'),
                                      ),
                                      const DropdownMenuItem(
                                        value: 60,
                                        child: Text('1m'),
                                      ),
                                      const DropdownMenuItem(
                                        value: 300,
                                        child: Text('5m'),
                                      ),
                                      const DropdownMenuItem(
                                        value: 600,
                                        child: Text('10m'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        _buildDivider(context),

                        // 更新保存时间间隔设置 (历史记录精度)
                        _buildSettingItem(
                          context,
                          icon: Icons.save,
                          label: l10n.updateSaveTime,
                          trailing: Transform.scale(
                            scale: 0.9,
                            child: Consumer<ThemeProvider>(
                              builder: (context, themeProvider, child) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    value: themeProvider.saveInterval,
                                    onChanged: (value) {
                                      if (value != null) {
                                        // 更新历史记录保存间隔
                                        themeProvider.changeSaveInterval(value);
                                      }
                                    },
                                    items: [
                                      const DropdownMenuItem(
                                        value: 60,
                                        child: Text('1m'),
                                      ),
                                      const DropdownMenuItem(
                                        value: 300,
                                        child: Text('5m'),
                                      ),
                                      const DropdownMenuItem(
                                        value: 600,
                                        child: Text('10m'),
                                      ),
                                      const DropdownMenuItem(
                                        value: 1800,
                                        child: Text('30m'),
                                      ),
                                      const DropdownMenuItem(
                                        value: 3600,
                                        child: Text('1h'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //开发者选项（仅在开发者模式开启时显示）
                if (_developerMode)
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.surface.withValues(alpha: 0.8),
                          theme.colorScheme.surface.withValues(alpha: 0.5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withValues(alpha: 0.1),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Section Header
                          Container(
                            padding: const EdgeInsets.all(16),
                            color: theme.colorScheme.primaryContainer
                                .withValues(alpha: 0.3),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.developer_mode,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '开发者选项',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildSettingItem(
                            context,
                            icon: Icons.auto_graph,
                            label: '生成测试数据',
                            trailing: Icon(
                              Icons.chevron_right,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            onTap: () {
                              _showGenerateTestDataDialog(context);
                            },
                          ),
                          _buildDivider(context),
                          _buildSettingItem(
                            context,
                            icon: Icons.delete_sweep,
                            label: '清除所有历史数据',
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Colors.red.withValues(alpha: 0.7),
                            ),
                            onTap: () {
                              _showClearDataDialog(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                //关于&赞助部分
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.surface.withValues(alpha: 0.8),
                        theme.colorScheme.surface.withValues(alpha: 0.5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withValues(alpha: 0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSettingItem(
                          context,
                          icon: Icons.info_outline,
                          label: l10n.about,
                          trailing: Icon(
                            Icons.chevron_right,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AboutPage(),
                              ),
                            );
                          },
                        ),
                        _buildDivider(context),
                        _buildSettingItem(
                          context,
                          icon: Icons.favorite_border,
                          label: l10n.sponsor,
                          trailing: Icon(
                            Icons.chevron_right,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          onTap: () async {
                            // 等待赞助页面返回
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SponsorPage(),
                              ),
                            );
                            // 返回后重新加载开发者模式状态
                            _loadDeveloperMode();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100), // Space for glass bar
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 显示生成测试数据对话框
  void _showGenerateTestDataDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: theme.colorScheme.surface,
          title: Row(
            children: [
              Icon(Icons.auto_graph, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              const Text('生成测试数据'),
            ],
          ),
          content: const Text(
            '这将为所有已添加的服务器生成过去 24 小时的模拟数据，用于测试折线图功能。\n\n'
            '注意：如果已经有真实数据，将会被覆盖。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                // 获取所有服务器
                final db = ServerListDataBase();
                final box = Hive.box('serverListBox');
                if (box.get("ITEMS") != null) {
                  db.loadData();
                  TestDataGenerator.generateForAllServers(db.items);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ 测试数据生成成功！请查看服务器详情页的折线图')),
                  );
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('⚠️ 请先添加服务器')));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primaryContainer,
              ),
              child: const Text('生成'),
            ),
          ],
        );
      },
    );
  }

  /// 显示清除数据对话框
  void _showClearDataDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: theme.colorScheme.surface,
          title: Row(
            children: [
              Icon(Icons.delete_sweep, color: Colors.red),
              const SizedBox(width: 12),
              const Text('清除历史数据'),
            ],
          ),
          content: const Text(
            '这将清除所有服务器的历史数据（用于折线图）。\n\n'
            '此操作不可恢复！',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                TestDataGenerator.clearAllTestData();
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('🗑️ 已清除所有历史数据')));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('清除', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        color: theme.colorScheme.surface.withValues(alpha: 0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: theme.colorScheme.secondary),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 20,
      endIndent: 20,
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.2),
    );
  }
}
