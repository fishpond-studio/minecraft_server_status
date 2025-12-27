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

  final List<Widget> _pages = [const Homepage(), const PictureChange()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
