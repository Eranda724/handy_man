enum ProviderSort {
  ratingHighToLow('Rating (high to low)'),
  rateLowToHigh('Hourly rate (low to high)'),
  experienceHighToLow('Experience (high to low)');

  final String label;
  const ProviderSort(this.label);
}
