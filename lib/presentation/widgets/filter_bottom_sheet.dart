import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:handy_man/core/enums/provider_sort.dart';
import 'package:handy_man/data/models/provider_filter.dart';
import 'package:handy_man/presentation/state/providers_notifier.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late ProviderFilter _tempFilter;

  @override
  void initState() {
    super.initState();
    _tempFilter = context.read<ProvidersNotifier>().filter;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter & Sort',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _tempFilter = ProviderFilter(
                        categoryId: _tempFilter.categoryId,
                      );
                    });
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Sort By',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButton<ProviderSort>(
              value: _tempFilter.sort,
              isExpanded: true,
              items: ProviderSort.values.map((sort) {
                return DropdownMenuItem(value: sort, child: Text(sort.label));
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _tempFilter = _tempFilter.copyWith(sort: val));
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Minimum Rating: ${_tempFilter.minRating.toStringAsFixed(1)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _tempFilter.minRating,
              min: 0,
              max: 5,
              divisions: 10,
              onChanged: (val) => setState(
                () => _tempFilter = _tempFilter.copyWith(minRating: val),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Hourly Rate (LKR): ${_tempFilter.minRate.toInt()} - ${_tempFilter.maxRate.toInt()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            RangeSlider(
              values: RangeValues(_tempFilter.minRate, _tempFilter.maxRate),
              min: ProviderFilter.minRateLimit,
              max: ProviderFilter.maxRateLimit,
              divisions: 40,
              onChanged: (val) => setState(
                () => _tempFilter = _tempFilter.copyWith(
                  minRate: val.start,
                  maxRate: val.end,
                ),
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Available Providers Only',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              value: _tempFilter.availableOnly,
              onChanged: (val) => setState(
                () => _tempFilter = _tempFilter.copyWith(availableOnly: val),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<ProvidersNotifier>().loadFirstPage(
                    newFilter: _tempFilter,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
