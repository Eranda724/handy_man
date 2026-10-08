import 'package:handy_man/core/enums/provider_sort.dart';

class ProviderFilter {
  static const double minRateLimit = 1000;
  static const double maxRateLimit = 5000;

  final String? categoryId;
  final String searchQuery;
  final double minRating;
  final double minRate;
  final double maxRate;
  final bool availableOnly;
  final ProviderSort sort;

  const ProviderFilter({
    this.categoryId,
    this.searchQuery = '',
    this.minRating = 0,
    this.minRate = minRateLimit,
    this.maxRate = maxRateLimit,
    this.availableOnly = false,
    this.sort = ProviderSort.ratingHighToLow,
  });

  int get activeCount {
    var count = 0;
    if (categoryId != null) count++;
    if (minRating > 0) count++;
    if (minRate != minRateLimit || maxRate != maxRateLimit) count++;
    if (availableOnly) count++;
    return count;
  }

  ProviderFilter copyWith({
    String? categoryId,
    bool clearCategory = false,
    String? searchQuery,
    double? minRating,
    double? minRate,
    double? maxRate,
    bool? availableOnly,
    ProviderSort? sort,
  }) {
    return ProviderFilter(
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      searchQuery: searchQuery ?? this.searchQuery,
      minRating: minRating ?? this.minRating,
      minRate: minRate ?? this.minRate,
      maxRate: maxRate ?? this.maxRate,
      availableOnly: availableOnly ?? this.availableOnly,
      sort: sort ?? this.sort,
    );
  }
}
