import 'package:flutter/material.dart';
import 'package:is_mc_fk_running/l10n/app_localizations.dart';
import 'home_page.dart';
import 'setting_page.dart';
import 'dart:ui';

class RoutesPages extends StatefulWidget {
  const RoutesPages({super.key});

  @override
  State<RoutesPages> createState() => _RoutesPagesState();
}

class _RoutesPagesState extends State<RoutesPages> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<Widget> _pages = [const Homepage(), const PictureChange()];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBody: true, // Allow body to flow behind bottom bar
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
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(
                alpha: 0.4,
              ), // Lower alpha for better glass effect
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.05),
                  width: 0.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent, // Important for glass effect
              currentIndex: _currentIndex,
              onTap: (int index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_rounded, size: 24),
                  label: l10n.home,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings_rounded, size: 24),
                  label: l10n.settings,
                ),
              ],
              selectedItemColor: colorScheme.primary,
              unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.5),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
            ),
          ),
        ),
      ),
    );
  }
}
