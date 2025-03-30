import 'package:flutter/material.dart';
import 'package:rizzlr/pages/findfriends.dart';
import 'package:rizzlr/pages/homePage.dart';
import 'package:rizzlr/pages/profile.dart';
import 'package:rizzlr/pages/settings.dart';
import 'components/neumorphicboxthin.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _pages = [
    HomePage(),
    ProfilePage(),
    Settings(),
  ];

  int _selectedIndex = 0; // Track the selected index
  final PageController _pageController = PageController(); // Add PageController

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onIconButtonTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage( // Smoothly transition to the new page
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: PageView(
        controller: _pageController, // Use the PageController
        children: _pages,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe gestures
      ),
      
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NeuThinBox(
          child: SizedBox(
            height: 70.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_pages.length, (index) {
                return IconButton(
                  icon: _buildIconForPage(index),
                  onPressed: () => _onIconButtonTapped(index),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to return the correct icon for each page
  Icon _buildIconForPage(int index) {
    IconData iconData = _getIconForPage(index);
    return Icon(
      iconData,
      color: _selectedIndex == index
          ? Theme.of(context).colorScheme.primary // Highlight selected icon
          : Theme.of(context).colorScheme.onSurface,
      size: _selectedIndex == index ? 30.0 : 25.0,
    );
  }

  IconData _getIconForPage(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.person;
      case 2:
        return Icons.local_activity;
      case 3:
        return Icons.settings;
      default:
        return Icons.home;
    }
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the controller to free resources
    super.dispose();
  }
}
