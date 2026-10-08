import 'package:flutter/material.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String bookingId;

  const BookingConfirmationScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmed'),
        automaticallyImplyLeading: false, // Hide the back button
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 24),
              const Text(
                'Your booking was successful!',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              Text(
                'Booking ID: $bookingId',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
