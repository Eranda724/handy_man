import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:handy_man/core/enums/provider_list_state.dart';
import 'package:handy_man/presentation/state/providers_notifier.dart';
import 'package:handy_man/presentation/widgets/filter_bottom_sheet.dart';
import 'package:handy_man/presentation/screens/provider_detail/provider_detail_screen.dart';

class ProviderListScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ProviderListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ProviderListScreen> createState() => _ProviderListScreenState();
}

class _ProviderListScreenState extends State<ProviderListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = context.read<ProvidersNotifier>();
      final filter = notifier.filter.copyWith(
        categoryId: widget.categoryId,
        clearCategory: false,
      );
      notifier.loadFirstPage(newFilter: filter);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProvidersNotifier>().loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ProvidersNotifier>();
    final activeCount = notifier.filter.activeCount;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => const FilterBottomSheet(),
                  );
                },
              ),
              if (activeCount > 0)
                Positioned(
                  right: 8,
                  top: 12,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      activeCount.toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _buildBody(notifier),
    );
  }

  Widget _buildBody(ProvidersNotifier notifier) {
    switch (notifier.state) {
      case ProviderListState.initial:
      case ProviderListState.loading:
        return const Center(child: CircularProgressIndicator());
      case ProviderListState.empty:
        return const Center(child: Text('No providers found.'));
      case ProviderListState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Failed to load providers. Please try again.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => notifier.loadFirstPage(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      case ProviderListState.success:
        return RefreshIndicator(
          onRefresh: () => notifier.loadFirstPage(),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: notifier.providers.length + 1,
            itemBuilder: (context, index) {
              if (index == notifier.providers.length) {
                if (notifier.loadMoreError) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('Network error while loading more.'),
                        TextButton(
                          onPressed: () => notifier.loadNextPage(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (notifier.hasMore && notifier.isLoadingMore) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }

              final provider = notifier.providers[index];
              return ListTile(
                leading: CircleAvatar(child: Text(provider.name[0])),
                title: Text(provider.name),
                subtitle: Text(
                  '★ ${provider.rating} • LKR ${provider.hourlyRate}/hr',
                ),
                trailing: Chip(
                  label: Text(provider.isAvailable ? 'Available' : 'Busy'),
                  backgroundColor: provider.isAvailable
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProviderDetailScreen(provider: provider),
                    ),
                  );
                },
              );
            },
          ),
        );
    }
  }
}
