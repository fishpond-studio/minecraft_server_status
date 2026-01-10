import 'package:flutter/material.dart';
import 'package:is_mc_fk_running/l10n/app_localizations.dart';
import 'package:is_mc_fk_running/pages/sponsor_page.dart';
import 'package:provider/provider.dart';
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
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          l10n.settings,
          style: TextStyle(
            fontFamily: theme.textTheme.bodyMedium?.fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: theme.colorScheme.primary,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              theme.colorScheme.primary.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
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
            ],
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
                    fontFamily: 'FMinecraft',
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
