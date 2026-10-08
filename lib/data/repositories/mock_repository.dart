import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:handy_man/data/models/category.dart';
import 'package:handy_man/data/models/paged_result.dart';
import 'package:handy_man/data/models/provider_filter.dart';
import 'package:handy_man/data/models/service_provider.dart';
import 'package:handy_man/data/repositories/provider_repository.dart';
import 'package:handy_man/core/enums/provider_sort.dart';

class MockProviderRepository implements ProviderRepository {
  final Random _random = Random();
  Map<String, dynamic>? _cache;

  Future<void> _simulateNetwork() async {
    final delayMs = 800 + _random.nextInt(701);
    await Future.delayed(Duration(milliseconds: delayMs));
    if (_random.nextDouble() < 0.2) {
      throw Exception('Network error. Please try again.');
    }
  }

  Future<Map<String, dynamic>> _loadJson() async {
    if (_cache != null) return _cache!;
    final text = await rootBundle.loadString('assets/data/providers.json');
    _cache = jsonDecode(text) as Map<String, dynamic>;
    return _cache!;
  }

  @override
  Future<List<Category>> getCategories() async {
    await _simulateNetwork();
    final data = await _loadJson();
    final list = data['categories'] as List;
    return list
        .map((c) => Category.fromJson(c as Map<String, dynamic>))
        .toList();
  }

  bool _matches(ServiceProvider p, ProviderFilter f) {
    if (f.categoryId != null && p.categoryId != f.categoryId) return false;
    if (f.availableOnly && !p.isAvailable) return false;
    if (p.rating < f.minRating) return false;
    if (p.hourlyRate < f.minRate || p.hourlyRate > f.maxRate) return false;

    if (f.searchQuery.isNotEmpty) {
      final query = f.searchQuery.trim().toLowerCase();
      final nameMatches = p.name.toLowerCase().contains(query);
      final skillMatches = p.skills.any((s) => s.toLowerCase().contains(query));
      if (!nameMatches && !skillMatches) return false;
    }

    return true;
  }

  @override
  Future<PagedResult> getProviders({
    required int page,
    required ProviderFilter filter,
  }) async {
    await _simulateNetwork();
    final data = await _loadJson();
    final list = data['providers'] as List;

    final allProviders = list
        .map((p) => ServiceProvider.fromJson(p as Map<String, dynamic>))
        .toList();

    var filtered = allProviders.where((p) => _matches(p, filter)).toList();

    switch (filter.sort) {
      case ProviderSort.ratingHighToLow:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ProviderSort.rateLowToHigh:
        filtered.sort((a, b) => a.hourlyRate.compareTo(b.hourlyRate));
        break;
      case ProviderSort.experienceHighToLow:
        filtered.sort((a, b) => b.experienceYears.compareTo(a.experienceYears));
        break;
    }

    final startIndex = (page - 1) * ProviderRepository.pageSize;
    if (startIndex >= filtered.length) {
      return const PagedResult(items: [], hasMore: false);
    }

    final endIndex = min(
      startIndex + ProviderRepository.pageSize,
      filtered.length,
    );
    final pagedItems = filtered.sublist(startIndex, endIndex);
    final hasMore = endIndex < filtered.length;

    return PagedResult(items: pagedItems, hasMore: hasMore);
  }
}
