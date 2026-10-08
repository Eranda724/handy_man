enum BookingStatus {
  pending('Pending'),
  confirmed('Confirmed'),
  inProgress('In Progress'),
  completed('Completed'),
  cancelled('Cancelled'),
  rejected('Rejected');

  final String label;
  const BookingStatus(this.label);

  /// Active = can still block a time slot (double-booking rule)
  /// and belongs in the "Upcoming" tab.
  bool get isActive =>
      this == pending || this == confirmed || this == inProgress;
}
