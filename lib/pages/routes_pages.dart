import 'package:flutter/material.dart';
import 'package:mc_sentinel/l10n/app_localizations.dart';
import 'home_page.dart';
import 'setting_page.dart';
import 'dart:ui';

class RoutesPages extends StatefulWidget {
  const RoutesPages({super.key});

  @override
  State<RoutesPages> createState() => _RoutesPagesState();
}

class _RoutesPagesState extends State<RoutesPages>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  late AnimationController _animationController;

  final List<Widget> _pages = [const Homepage(), const PictureChange()];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        physics: const BouncingScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: _buildModernNavBar(l10n, colorScheme),
    );
  }

  Widget _buildModernNavBar(AppLocalizations l10n, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      height: 80, // 增加高度以修复溢出
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.surface.withValues(alpha: 0.8),
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.15),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.home_rounded,
                    label: l10n.home,
                    index: 0,
                    colorScheme: colorScheme,
                  ),
                  _buildNavItem(
                    icon: Icons.settings_rounded,
                    label: l10n.settings,
                    index: 1,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required ColorScheme colorScheme,
  }) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) {
          _animationController.reverse();
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
          );
        },
        onTapCancel: () => _animationController.reverse(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primaryContainer.withValues(alpha: 0.4)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isSelected ? 26 : 24,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                style: TextStyle(
                  fontSize: isSelected ? 12 : 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.6),
                  letterSpacing: 0.2,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
