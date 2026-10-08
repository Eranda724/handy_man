import 'package:handy_man/core/enums/booking_status.dart';
import 'package:handy_man/core/enums/time_slot.dart';

class Booking {
  final String id;
  final String providerId;
  final String providerName;
  final String serviceName;
  final String customerName;
  final String phone;
  final String address;
  final DateTime date;
  final TimeSlot timeSlot;
  final int estimatedHours;
  final String jobDescription;
  final double labourCost;
  final double visitingCharge;
  final double weekendSurcharge;
  final double totalCost;
  final BookingStatus status;
  final DateTime createdAt;
  final bool isReviewed;

  const Booking({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.serviceName,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.date,
    required this.timeSlot,
    required this.estimatedHours,
    required this.jobDescription,
    required this.labourCost,
    required this.visitingCharge,
    required this.weekendSurcharge,
    required this.totalCost,
    required this.status,
    required this.createdAt,
    this.isReviewed = false,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      serviceName: json['serviceName'] as String,
      customerName: json['customerName'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      date: DateTime.parse(json['date'] as String),
      timeSlot: TimeSlot.values.byName(json['timeSlot'] as String),
      estimatedHours: json['estimatedHours'] as int,
      jobDescription: json['jobDescription'] as String,
      labourCost: (json['labourCost'] as num).toDouble(),
      visitingCharge: (json['visitingCharge'] as num).toDouble(),
      weekendSurcharge: (json['weekendSurcharge'] as num).toDouble(),
      totalCost: (json['totalCost'] as num).toDouble(),
      status: BookingStatus.values.byName(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isReviewed: json['isReviewed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerId': providerId,
      'providerName': providerName,
      'serviceName': serviceName,
      'customerName': customerName,
      'phone': phone,
      'address': address,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot.name,
      'estimatedHours': estimatedHours,
      'jobDescription': jobDescription,
      'labourCost': labourCost,
      'visitingCharge': visitingCharge,
      'weekendSurcharge': weekendSurcharge,
      'totalCost': totalCost,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'isReviewed': isReviewed,
    };
  }

  Booking copyWith({
    String? id,
    String? providerId,
    String? providerName,
    String? serviceName,
    String? customerName,
    String? phone,
    String? address,
    DateTime? date,
    TimeSlot? timeSlot,
    int? estimatedHours,
    String? jobDescription,
    double? labourCost,
    double? visitingCharge,
    double? weekendSurcharge,
    double? totalCost,
    BookingStatus? status,
    DateTime? createdAt,
    bool? isReviewed,
  }) {
    return Booking(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      serviceName: serviceName ?? this.serviceName,
      customerName: customerName ?? this.customerName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      jobDescription: jobDescription ?? this.jobDescription,
      labourCost: labourCost ?? this.labourCost,
      visitingCharge: visitingCharge ?? this.visitingCharge,
      weekendSurcharge: weekendSurcharge ?? this.weekendSurcharge,
      totalCost: totalCost ?? this.totalCost,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      isReviewed: isReviewed ?? this.isReviewed,
    );
  }
}
