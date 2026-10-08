enum TimeSlot {
  eightToTen('8–10 AM', 8, 10),
  tenToTwelve('10–12 PM', 10, 12),
  oneToThree('1–3 PM', 13, 15),
  threeToFive('3–5 PM', 15, 17);

  final String label;
  final int startHour;
  final int endHour;

  const TimeSlot(this.label, this.startHour, this.endHour);
}
