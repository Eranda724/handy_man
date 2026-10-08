import 'dart:async';

import 'package:flutter/material.dart';
import 'package:handy_man/presentation/screens/provider_list/provider_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _debounce;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (query.isNotEmpty) {
        debugPrint('Navigating to search: $query');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FixIt Services')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search providers or skills...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: const [
                _CategoryCard(
                  name: 'Plumbing',
                  icon: Icons.plumbing,
                  id: 'plumbing',
                ),
                _CategoryCard(
                  name: 'Electrical',
                  icon: Icons.electrical_services,
                  id: 'electrical',
                ),
                _CategoryCard(
                  name: 'Carpentry',
                  icon: Icons.handyman,
                  id: 'carpentry',
                ),
                _CategoryCard(
                  name: 'Painting',
                  icon: Icons.format_paint,
                  id: 'painting',
                ),
                _CategoryCard(
                  name: 'AC Repair',
                  icon: Icons.ac_unit,
                  id: 'ac_repair',
                ),
                _CategoryCard(
                  name: 'Cleaning',
                  icon: Icons.cleaning_services,
                  id: 'cleaning',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final String id;

  const _CategoryCard({
    required this.name,
    required this.icon,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProviderListScreen(categoryId: id, categoryName: name),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
