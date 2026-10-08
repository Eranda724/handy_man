import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:handy_man/core/enums/booking_status.dart';
import 'package:handy_man/data/models/booking.dart';
import 'package:handy_man/presentation/state/bookings_notifier.dart';
import 'package:handy_man/presentation/state/providers_notifier.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<BookingsNotifier>().bookings;

    final upcoming = bookings.where((b) => b.status.isActive).toList();
    final history = bookings.where((b) => !b.status.isActive).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Bookings'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(upcoming, context),
            _buildList(history, context),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Booking> list, BuildContext context) {
    if (list.isEmpty) {
      return const Center(child: Text('No bookings found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final booking = list[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      booking.providerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Chip(
                      label: Text(booking.status.label),
                      backgroundColor: _getStatusColor(booking.status),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${booking.serviceName} • ${DateFormat('yyyy-MM-dd').format(booking.date)} • ${booking.timeSlot.label}',
                ),
                Text('Total Cost: LKR ${booking.totalCost.toStringAsFixed(2)}'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_canCancel(booking))
                      TextButton(
                        onPressed: () => _confirmCancel(context, booking.id),
                        child: const Text(
                          'Cancel Booking',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    if (booking.status == BookingStatus.completed &&
                        !booking.isReviewed)
                      ElevatedButton(
                        onPressed: () => _showRatingDialog(context, booking),
                        child: const Text('Rate Provider'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _canCancel(Booking booking) {
    if (booking.status != BookingStatus.pending &&
        booking.status != BookingStatus.confirmed) {
      return false;
    }
    final difference = booking.date.difference(DateTime.now());
    return difference.inHours > 24;
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange.shade100;
      case BookingStatus.confirmed:
        return Colors.blue.shade100;
      case BookingStatus.inProgress:
        return Colors.purple.shade100;
      case BookingStatus.completed:
        return Colors.green.shade100;
      case BookingStatus.cancelled:
      case BookingStatus.rejected:
        return Colors.red.shade100;
    }
  }

  Future<void> _confirmCancel(BuildContext context, String bookingId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking?'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      context.read<BookingsNotifier>().cancelBooking(bookingId);
    }
  }

  Future<void> _showRatingDialog(BuildContext context, Booking booking) async {
    double stars = 5.0;
    final commentController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Rate Provider'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: stars,
                min: 1,
                max: 5,
                divisions: 4,
                label: stars.toStringAsFixed(0),
                onChanged: (val) => setState(() => stars = val),
              ),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(hintText: 'Optional comment'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<ProvidersNotifier>().addReviewToProvider(
                  booking.providerId,
                  stars,
                );
                context.read<BookingsNotifier>().markAsReviewed(booking.id);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
