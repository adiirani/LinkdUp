import 'package:flutter/material.dart';
import 'package:rizzlr/pages/homePage.dart';
import 'package:rizzlr/pages/profile.dart';
import 'components/neumorphicboxthin.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List _pages = [
    HomePage(),
    Profile()
  ];

  int _selectedIndex = 0; // Track the selected index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          // Main content area
          Expanded(
            child: Center(
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NeuThinBox(
        child: SizedBox(
          height: 70.0, // Set the height of the bottom navigation bar here
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Transform.scale(
                  scale: 1.1, // Scale icon by 1.1
                  child: const Icon(Icons.home),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Transform.scale(
                  scale: 1.1, // Scale icon by 1.1
                  child: const Icon(Icons.people),
                ),
                label: 'Leaderboard',
              ),
              BottomNavigationBarItem(
                icon: Transform.scale(
                  scale: 1.1, // Scale icon by 1.1
                  child: const Icon(Icons.person),
                ),
                label: 'Music',
              ),
              BottomNavigationBarItem(
                icon: Transform.scale(
                  scale: 1.1, // Scale icon by 1.1
                  child: const Icon(Icons.settings),
                ),
                label: 'Settings',
              ),
            ],
            currentIndex: _selectedIndex, // Set the current index
            onTap: _onItemTapped, // Handle item tap
            type: BottomNavigationBarType.fixed, // Ensure it is fixed type
            selectedFontSize: 14 * 1.1, // Scale text size by 1.1
            unselectedFontSize: 12 * 1.1, // Scale unselected text size by 1.1
          ),
        ),
      ),
    );
  }
}