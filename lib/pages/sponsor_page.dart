import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:is_mc_fk_running/l10n/app_localizations.dart';

class SponsorPage extends StatelessWidget {
  const SponsorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isZh = Localizations.localeOf(context).languageCode == 'zh';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          l10n.sponsor,
          style: TextStyle(
            fontFamily: theme.textTheme.bodyMedium?.fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: theme.colorScheme.primary,
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInfoCard(context, theme, l10n),
                const SizedBox(height: 24),
                Text(
                  l10n.joinCommunity,
                  style: TextStyle(
                    fontFamily: 'FMinecraft',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                //中文版群聊卡片（QQ群）
                if (isZh) ...[
                  //QQ群
                  _buildCommunityCard(
                    context,
                    theme,
                    l10n,
                    title: 'QQ群', //卡片标题
                    name: 'IDK的狼窝', //群聊名称
                    id: '585579663', //QQ群号
                    icon: Icons.chat_bubble_outline, //图标
                    qrImagePath: 'lib/images/QR_code_1.png', //二维码图片路径
                  ),
                  const SizedBox(height: 16),
                  //QQ频道
                  _buildCommunityCard(
                    context,
                    theme,
                    l10n,
                    title: 'QQ群(是朋友的群聊呀)', //卡片标题
                    name: 'Furcraft', //群聊名称
                    id: '981957765', //QQ频道链接
                    icon: Icons.chat_bubble_outline, //图标
                    qrImagePath: 'lib/images/QR_code_2.png', //二维码图片路径
                  ),
                  //英文版群聊卡片（Discord/Telegram）
                ] else ...[
                  //Discord服务器
                  _buildCommunityCard(
                    context,
                    theme,
                    l10n,
                    title: 'Discord', //卡片标题
                    name:
                        'IDK\'s Wolfhome(actually it\'s not a discord server)', //Discord服务器名称
                    id: 'We don\'t have a discord server', //Discord邀请链接
                    icon: Icons.forum_outlined, //图标
                    isLink: true, //标记为链接格式
                  ),
                  const SizedBox(height: 16),
                  //Telegram频道
                  _buildCommunityCard(
                    context,
                    theme,
                    l10n,
                    title: 'Telegram', // 卡片标题
                    name:
                        'IDK Channel(actually it\'s not a telegram channel)', // Telegram频道名称
                    id: 'We don\'t have a telegram channel', // Telegram频道链接
                    icon: Icons.send_outlined, // 图标
                    isLink: true, // 标记为链接格式
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface.withValues(alpha: 0.8),
            theme.colorScheme.surface.withValues(alpha: 0.6),
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.favorite,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.sponsorTitle,
                      style: TextStyle(
                        fontFamily: 'FMinecraft',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                l10n.sponsorNote,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Divider(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
              const SizedBox(height: 16),
              Text(
                l10n.sponsorBenefitsTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              _buildBenefitItem(theme, l10n.sponsorBenefit1),
              const SizedBox(height: 8),
              _buildBenefitItem(theme, l10n.sponsorBenefit2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(ThemeData theme, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            Icons.check_circle_outline,
            size: 16,
            color: theme.colorScheme.tertiary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface),
          ),
        ),
      ],
    );
  }

  Widget _buildCommunityCard(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n, {
    required String title,
    required String name,
    required String id,
    required IconData icon,
    bool isLink = false,
    String? qrImagePath,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Clipboard.setData(ClipboardData(text: id));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${isLink ? "Link" : "ID"} Copied: $id'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.3,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: theme.colorScheme.primary, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            isLink ? Icons.link : Icons.numbers,
                            size: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              id,
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // ========== 二维码/QR码区域 ==========
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.1),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: qrImagePath != null
                        ? Image.asset(
                            qrImagePath,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Icon(
                              Icons.qr_code_2,
                              size: 60,
                              color: Colors.black87,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
