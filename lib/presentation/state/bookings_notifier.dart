import 'package:flutter/material.dart';
import 'package:handy_man/core/enums/time_slot.dart';
import 'package:handy_man/data/models/booking.dart';
import 'package:handy_man/domain/double_booking.dart';
import 'package:handy_man/core/enums/booking_status.dart';
import 'package:handy_man/domain/booking_logic.dart';

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class BookingsNotifier extends ChangeNotifier {
  final SharedPreferences _prefs;
  final List<Booking> _bookings = [];

  BookingsNotifier(this._prefs) {
    _loadBookings();
  }

  void _loadBookings() {
    final String? bookingsJson = _prefs.getString('bookings');
    if (bookingsJson != null) {
      final List<dynamic> decoded = jsonDecode(bookingsJson);
      _bookings.addAll(
        decoded.map((b) => Booking.fromJson(b as Map<String, dynamic>)),
      );
      notifyListeners();
    }
  }

  void _saveBookings() {
    final String encoded = jsonEncode(
      _bookings.map((b) => b.toJson()).toList(),
    );
    _prefs.setString('bookings', encoded);
  }

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
    _saveBookings();
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

  void cancelBooking(String id) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(
        status: BookingStatus.cancelled,
      );
      notifyListeners();
      _saveBookings();
    }
  }

  void markAsReviewed(String id) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(isReviewed: true);
      notifyListeners();
      _saveBookings();
    }
  }

  void updateBookingStatus(String id, BookingStatus newStatus) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      final currentStatus = _bookings[index].status;
      if (BookingStatusRules.canTransition(currentStatus, newStatus)) {
        _bookings[index] = _bookings[index].copyWith(status: newStatus);
        notifyListeners();
        _saveBookings();
      } else {
        throw Exception(
          'Blocked in business logic: Invalid transition from ${currentStatus.name} to ${newStatus.name}',
        );
      }
    }
  }
}
