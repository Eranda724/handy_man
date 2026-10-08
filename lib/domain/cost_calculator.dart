class CostCalculator {
  static const double visitingCharge = 500.0;

  static double calculateTotal({
    required double hourlyRate,
    required int estimatedHours,
    required DateTime date,
  }) {
    final double labourCost = hourlyRate * estimatedHours;
    double weekendSurcharge = 0.0;

    if (date.weekday == DateTime.saturday) {
      weekendSurcharge = labourCost * 0.15;
    }

    return labourCost + visitingCharge + weekendSurcharge;
  }
}