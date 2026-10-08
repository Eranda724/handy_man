import 'package:handy_man/data/models/service_provider.dart';

class PagedResult {
  final List<ServiceProvider> items;
  final bool hasMore;

  const PagedResult({required this.items, required this.hasMore});
}
