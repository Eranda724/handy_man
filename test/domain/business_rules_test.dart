import 'package:flutter_test/flutter_test.dart';
import 'package:handy_man/core/enums/booking_status.dart';
import 'package:handy_man/core/enums/time_slot.dart';
import 'package:handy_man/data/models/booking.dart';
import 'package:handy_man/domain/cost_calculator.dart';
import 'package:handy_man/domain/booking_logic.dart';
import 'package:handy_man/domain/double_booking.dart';
import 'package:handy_man/domain/validators.dart';

void main() {
  test('Cost calculation includes 15% surcharge on Saturdays', () {
    final weekdayDate = DateTime(2026, 10, 9); // Friday
    final weekdayCost = CostCalculator.calculateTotal(
      hourlyRate: 1000,
      estimatedHours: 2,
      date: weekdayDate,
    );
    expect(weekdayCost, 2500.0); // 2000 + 500

    final saturdayDate = DateTime(2026, 10, 10); // Saturday
    final saturdayCost = CostCalculator.calculateTotal(
      hourlyRate: 1000,
      estimatedHours: 2,
      date: saturdayDate,
    );
    expect(saturdayCost, 2800.0); // 2000 + 500 + 300(15%)
  });

  test('Valid and blocked status transitions', () {
    expect(
      BookingStatusRules.canTransition(
        BookingStatus.pending,
        BookingStatus.confirmed,
      ),
      isTrue,
    );
    expect(
      BookingStatusRules.canTransition(
        BookingStatus.completed,
        BookingStatus.pending,
      ),
      isFalse,
    );
  });

  test('Phone validator accepts valid formats and rejects invalid ones', () {
    expect(Validators.validatePhone('0771234567'), isNull);
    expect(Validators.validatePhone('+94771234567'), isNull);
    expect(Validators.validatePhone('0112345678'), isNotNull);
  });

  test('Double booking blocks overlapping active slots', () {
    final existingBooking = Booking(
      id: '1',
      providerId: 'p001',
      providerName: 'Kamal',
      serviceName: 'Plumbing',
      customerName: 'Test',
      phone: '0771234567',
      address: 'Test',
      date: DateTime(2026, 10, 10),
      timeSlot: TimeSlot.eightToTen,
      estimatedHours: 2,
      jobDescription: 'Test',
      labourCost: 100,
      visitingCharge: 500,
      weekendSurcharge: 0,
      totalCost: 600,
      status: BookingStatus.confirmed,
      createdAt: DateTime.now(),
    );

    final isAvailable = DoubleBookingChecker.isSlotAvailable(
      [existingBooking],
      'p001',
      DateTime(2026, 10, 10),
      TimeSlot.eightToTen,
    );
    expect(isAvailable, isFalse);
  });
}
