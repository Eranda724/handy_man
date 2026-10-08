import 'package:flutter/material.dart';
import 'package:handy_man/core/enums/time_slot.dart';
import 'package:handy_man/data/models/booking.dart';
import 'package:handy_man/domain/double_booking.dart';

class BookingsNotifier extends ChangeNotifier {
  final List<Booking> _bookings = [];

  List<Booking> get bookings => _bookings;

  bool addBooking(Booking booking) {
    // check double booking
    final isAvailable = DoubleBookingChecker.isSlotAvailable(
      _bookings,
      booking.providerId,
      booking.date,
      booking.timeSlot,
    );
    if (!isAvailable) return false;

    _bookings.add(booking);
    notifyListeners();
    return true;
  }

  // get booked slots for a date
  List<TimeSlot> getBookedSlots(String providerId, DateTime date) {
    return _bookings
        .where(
          (b) =>
              b.providerId == providerId &&
              b.date.year == date.year &&
              b.date.month == date.month &&
              b.date.day == date.day &&
              b.status.isActive,
        )
        .map((b) => b.timeSlot)
        .toList();
  }
}
