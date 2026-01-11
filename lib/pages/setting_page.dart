import 'package:flutter/material.dart';
import 'package:is_mc_fk_running/l10n/app_localizations.dart';
import 'package:is_mc_fk_running/pages/sponsor_page.dart';
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

                        //更新时间
                        _buildSettingItem(
                          context,
                          icon: Icons.update,
                          label: l10n.updateTime,
                          trailing: Transform.scale(
                            scale: 0.9,
                            child: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        _buildDivider(context),

                        //更新保存时间
                        _buildSettingItem(
                          context,
                          icon: Icons.save,
                          label: l10n.updateSaveTime,
                          trailing: Transform.scale(
                            scale: 0.9,
                            child: const Icon(Icons.arrow_forward_ios),
                          ),
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SponsorPage(),
                              ),
                            );
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
