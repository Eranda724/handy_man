import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:handy_man/presentation/state/mode_notifier.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isProvider = context.watch<ModeNotifier>().isProviderMode;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text(
              'Provider Mode (Kamal Perera)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Switch to manage incoming jobs'),
            value: isProvider,
            onChanged: (val) => context.read<ModeNotifier>().toggleMode(),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text(
              'Dark Mode',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Toggle app theme'),
            value: context.watch<ModeNotifier>().isDarkMode,
            onChanged: (val) => context.read<ModeNotifier>().toggleTheme(),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Account Details'),
            subtitle: Text('ID: p001\nName: Kamal Perera\nCategory: Plumbing'),
          ),
        ],
      ),
    );
  }
}
