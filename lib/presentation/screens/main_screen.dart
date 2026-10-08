import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:handy_man/presentation/state/mode_notifier.dart';
import 'package:handy_man/presentation/screens/home/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isProvider = context.watch<ModeNotifier>().isProviderMode;

    final screens = [
      const HomeScreen(),
      const Center(child: Text('Bookings / Jobs Screen (Pending)')),
      const Center(child: Text('Profile Screen (Pending)')),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_alt),
            label: isProvider ? 'Jobs' : 'Bookings',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
