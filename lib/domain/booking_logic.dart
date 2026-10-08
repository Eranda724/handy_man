import 'package:handy_man/core/enums/booking_status.dart';

class BookingStatusRules {
  static bool canTransition(BookingStatus current, BookingStatus next) {
    switch (current) {
      case BookingStatus.pending:
        return next == BookingStatus.confirmed ||
            next == BookingStatus.rejected ||
            next == BookingStatus.cancelled;
      case BookingStatus.confirmed:
        return next == BookingStatus.inProgress ||
            next == BookingStatus.cancelled;
      case BookingStatus.inProgress:
        return next == BookingStatus.completed;
      default:
        return false;
    }
  }
}
