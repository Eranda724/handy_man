import 'package:handy_man/data/models/booking.dart';
import 'package:handy_man/core/enums/time_slot.dart';

class DoubleBookingChecker {
  static bool isSlotAvailable(
    List<Booking> existingBookings,
    String providerId,
    DateTime date,
    TimeSlot timeSlot,
  ) {
    for (final booking in existingBookings) {
      if (booking.providerId == providerId &&
          booking.date.year == date.year &&
          booking.date.month == date.month &&
          booking.date.day == date.day &&
          booking.timeSlot == timeSlot &&
          booking.status.isActive) {
        return false;
      }
    }
    return true;
  }
}
