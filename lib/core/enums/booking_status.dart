enum BookingStatus {
  pending('Pending'),
  confirmed('Confirmed'),
  inProgress('In Progress'),
  completed('Completed'),
  cancelled('Cancelled'),
  rejected('Rejected');

  final String label;
  const BookingStatus(this.label);

  bool get isActive =>
      this == pending || this == confirmed || this == inProgress;
}
