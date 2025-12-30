import 'package:flutter/material.dart';
import 'home_page.dart';
import 'setting_page.dart';

class RoutesPages extends StatefulWidget {
  const RoutesPages({super.key});

  @override
  State<RoutesPages> createState() => _RoutesPagesState();
}

class _RoutesPagesState extends State<RoutesPages> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<Widget> _pages = [
    const Homepage(),
    const PictureChange(),
  ]; // 使用正确的Widget名称

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ), // 使用弹性滚动物理效果，确保总是可以滚动
        scrollDirection: Axis.horizontal,
        children: _pages, // 确保水平滚动
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.15),
        currentIndex: _currentIndex,
        onTap: (int index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 20),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 20),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.3),
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
