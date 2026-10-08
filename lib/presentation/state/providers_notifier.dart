import 'package:flutter/material.dart';
import 'package:handy_man/core/enums/provider_list_state.dart';
import 'package:handy_man/data/models/provider_filter.dart';
import 'package:handy_man/data/models/service_provider.dart';
import 'package:handy_man/data/repositories/mock_repository.dart';
import 'package:handy_man/data/repositories/provider_repository.dart';

class ProvidersNotifier extends ChangeNotifier {
  final ProviderRepository _repository = MockProviderRepository();

  List<ServiceProvider> _providers = [];
  ProviderListState _state = ProviderListState.initial;
  ProviderFilter _filter = const ProviderFilter();
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  bool _loadMoreError = false;

  List<ServiceProvider> get providers => _providers;
  ProviderListState get state => _state;
  ProviderFilter get filter => _filter;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  bool get loadMoreError => _loadMoreError;

  Future<void> loadFirstPage({ProviderFilter? newFilter}) async {
    if (newFilter != null) {
      _filter = newFilter;
    }
    _currentPage = 1;
    _state = ProviderListState.loading;
    _loadMoreError = false;
    notifyListeners();

    try {
      final result = await _repository.getProviders(
        page: _currentPage,
        filter: _filter,
      );
      _providers = result.items;
      _hasMore = result.hasMore;
      _state = _providers.isEmpty
          ? ProviderListState.empty
          : ProviderListState.success;
    } catch (e) {
      _state = ProviderListState.error;
    }
    notifyListeners();
  }

  Future<void> loadNextPage() async {
    if (_isLoadingMore || !_hasMore || _state != ProviderListState.success) {
      return;
    }

    _isLoadingMore = true;
    _loadMoreError = false;
    notifyListeners();

    try {
      final result = await _repository.getProviders(
        page: _currentPage + 1,
        filter: _filter,
      );
      _currentPage++;
      _providers.addAll(result.items);
      _hasMore = result.hasMore;
    } catch (e) {
      _loadMoreError = true;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void addReviewToProvider(String providerId, double newStars) {
    final index = _providers.indexWhere((p) => p.id == providerId);
    if (index != -1) {
      final p = _providers[index];
      final newCount = p.reviewCount + 1;
      // rating
      final updatedRating = ((p.rating * p.reviewCount) + newStars) / newCount;

      _providers[index] = p.copyWith(
        rating: double.parse(updatedRating.toStringAsFixed(1)),
        reviewCount: newCount,
      );
      notifyListeners();
    }
  }
}
