import 'package:flutter/material.dart';
import 'package:handy_man/data/models/service_provider.dart';
import 'package:handy_man/presentation/screens/booking/booking_screen.dart';

class ProviderDetailScreen extends StatelessWidget {
  final ServiceProvider provider;

  const ProviderDetailScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Provider Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  child: Text(
                    provider.name[0],
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        provider.location,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          Text(
                            ' ${provider.rating} (${provider.reviewCount} reviews)',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat('Experience', '${provider.experienceYears} Yrs'),
                _buildStat('Completed', '${provider.completedJobs} Jobs'),
                _buildStat('Rate', 'LKR ${provider.hourlyRate}/hr'),
              ],
            ),
            const Divider(height: 32),
            const Text(
              'About',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(provider.description),
            const SizedBox(height: 24),
            const Text(
              'Skills',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: provider.skills
                  .map((skill) => Chip(label: Text(skill)))
                  .toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: provider.isAvailable
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(provider: provider),
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              provider.isAvailable ? 'Book Now' : 'Provider is Busy',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
