import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:handy_man/core/enums/booking_status.dart';
import 'package:handy_man/data/models/booking.dart';
import 'package:handy_man/presentation/state/bookings_notifier.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final allBookings = context.watch<BookingsNotifier>().bookings;
    // get me as p001
    final myJobs = allBookings.where((b) => b.providerId == 'p001').toList();

    final pendingCount = myJobs
        .where((b) => b.status == BookingStatus.pending)
        .length;
    final completedJobs = myJobs.where(
      (b) => b.status == BookingStatus.completed,
    );
    final totalEarnings = completedJobs.fold(
      0.0,
      (sum, b) => sum + b.totalCost,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Provider Jobs')),
      body: Column(
        children: [
          _buildSummary(context, pendingCount, totalEarnings),
          Expanded(
            child: myJobs.isEmpty
                ? const Center(child: Text('No jobs available.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: myJobs.length,
                    itemBuilder: (context, index) =>
                        _buildJobCard(context, myJobs[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context, int pending, double earnings) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      color: isDark ? Colors.indigo.shade900 : Colors.indigo.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Text(
                'Pending Jobs',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '$pending',
                style: const TextStyle(fontSize: 24, color: Colors.orange),
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                'Total Earnings',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'LKR ${earnings.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, Booking job) {
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
                  job.customerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Chip(label: Text(job.status.label)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${DateFormat('yyyy-MM-dd').format(job.date)} | ${job.timeSlot.label}',
            ),
            Text('Expected Earnings: LKR ${job.totalCost.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            _buildActionButtons(context, job),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Booking job) {
    final notifier = context.read<BookingsNotifier>();

    if (job.status == BookingStatus.pending) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () =>
                notifier.updateBookingStatus(job.id, BookingStatus.rejected),
            child: const Text('Reject', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () =>
                notifier.updateBookingStatus(job.id, BookingStatus.confirmed),
            child: const Text('Accept'),
          ),
        ],
      );
    } else if (job.status == BookingStatus.confirmed) {
      return Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () =>
              notifier.updateBookingStatus(job.id, BookingStatus.inProgress),
          child: const Text('Start Job'),
        ),
      );
    } else if (job.status == BookingStatus.inProgress) {
      return Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () =>
              notifier.updateBookingStatus(job.id, BookingStatus.completed),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text('Mark Complete'),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
