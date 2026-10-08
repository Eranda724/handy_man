import 'package:handy_man/data/models/category.dart';
import 'package:handy_man/data/models/paged_result.dart';
import 'package:handy_man/data/models/provider_filter.dart';

abstract class ProviderRepository {
  static const int pageSize = 10;

  Future<List<Category>> getCategories();

  Future<PagedResult> getProviders({
    required int page,
    required ProviderFilter filter,
  });
}
