import 'dart:async';
import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freight_home_page/presentation/bloc/freight_listing_bloc.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freight_home_page/presentation/bloc/freight_listing_event.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freight_home_page/presentation/bloc/freight_listing_state.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freight_home_page/presentation/screen/freight_detail_screen.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freight_home_page/presentation/widgets/freight_card.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freight_home_page/presentation/widgets/freight_card_shimmer.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freight_home_page/presentation/widgets/freight_filter_sheet.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/entity/freight_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─── Entry point ─────────────────────────────────────────────────────────────

class FreightListingScreen extends StatelessWidget {
  const FreightListingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FreightListingBloc>()..add(const FetchFreightListing()),
      child: const _FreightListingView(),
    );
  }
}

// ─── Stateful view ───────────────────────────────────────────────────────────

class _FreightListingView extends StatefulWidget {
  const _FreightListingView();
  @override
  State<_FreightListingView> createState() => _FreightListingViewState();
}

class _FreightListingViewState extends State<_FreightListingView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Completer<void>? _refreshCompleter;
  static const _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent - _scrollThreshold) {
      context.read<FreightListingBloc>().add(const LoadMoreFreights());
    }
  }

  FreightFilter _activeFilter(FreightListingState state) {
    if (state is FreightListingSuccess) return state.activeFilter;
    if (state is FreightListingError) return state.activeFilter;
    return const FreightFilter();
  }

  Future<void> _openFilterSheet(FreightFilter current) async {
    final result = await showModalBottomSheet<FreightFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FreightFilterSheet(initial: current),
    );
    if (result == null || !mounted) return;
    if (result.isEmpty) {
      context.read<FreightListingBloc>().add(const ClearFreightFilter());
    } else {
      context.read<FreightListingBloc>().add(ApplyFreightFilter(result));
    }
  }

  Future<void> _openQuickSheet(FreightFilter current, _QuickGroup group) async {
    final result = await showModalBottomSheet<FreightFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SingleFilterSheet(group: group, activeFilter: current),
    );
    if (result == null || !mounted) return;
    context.read<FreightListingBloc>().add(ApplyFreightFilter(result));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0FA),
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<FreightListingBloc, FreightListingState>(
              buildWhen: (p, c) => _activeFilter(p) != _activeFilter(c),
              builder: (context, state) {
                final filter = _activeFilter(state);
                return _SearchAndFilterBar(
                  controller: _searchController,
                  activeFilter: filter,
                  onAllFiltersTap: () => _openFilterSheet(filter),
                  onClearFilter: () => context.read<FreightListingBloc>().add(
                    const ClearFreightFilter(),
                  ),
                  onQuickChipTap: (group) => _openQuickSheet(filter, group),
                );
              },
            ),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return BlocConsumer<FreightListingBloc, FreightListingState>(
      listener: (context, state) {
        if (state is FreightListingSuccess && !state.isRefreshing) {
          _refreshCompleter?.complete();
          _refreshCompleter = null;
        }
        if (state is FreightListingError) {
          _refreshCompleter?.complete();
          _refreshCompleter = null;
        }
      },
      builder: (context, state) {
        if (state is FreightListingLoading) {
          return const FreightListingShimmer();
        }
        if (state is FreightListingError) {
          return _ErrorView(
            message: state.message,
            onRetry: () => context.read<FreightListingBloc>().add(
              FetchFreightListing(filter: state.activeFilter),
            ),
          );
        }
        if (state is FreightListingSuccess) {
          if (state.freights.isEmpty && !state.isRefreshing) {
            return _EmptyView(
              hasFilter: !state.activeFilter.isEmpty,
              onClear: () => context.read<FreightListingBloc>().add(
                const ClearFreightFilter(),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () {
              _refreshCompleter = Completer<void>();
              context.read<FreightListingBloc>().add(
                const RefreshFreightListing(),
              );
              return _refreshCompleter!.future;
            },
            child: state.isRefreshing
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const FreightListingShimmer(),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: state.freights.length + 1,
                    itemBuilder: (context, index) {
                      if (index == state.freights.length) {
                        return _PaginationFooter(state: state);
                      }
                      final freight = state.freights[index];
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                FreightDetailScreen(freight: freight),
                          ),
                        ),
                        child: FreightCard(freight: freight, onPlaceBid: () {}),
                      );
                    },
                  ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ─── Search + Filter bar ─────────────────────────────────────────────────────

// Enum-backed quick-filter groups. Each maps to one FreightFilter field.
class _QuickGroup {
  final String label;
  final List<String> options;
  final List<String>? Function(FreightFilter) read;
  final FreightFilter Function(FreightFilter, List<String>?) write;

  const _QuickGroup({
    required this.label,
    required this.options,
    required this.read,
    required this.write,
  });
}

final _quickGroups = <_QuickGroup>[
  _QuickGroup(
    label: 'Cargo Type',
    options: [
      'Electronics',
      'Food Stuff',
      'Construction',
      'Chemicals',
      'Textile',
    ],
    read: (f) => f.cargoTypes,
    write: (f, v) => FreightFilter(
      cargoTypes: v,
      truckTypes: f.truckTypes,
      pricingTypes: f.pricingTypes,
      statuses: f.statuses,
      pickupRegion: f.pickupRegion,
      pickupCity: f.pickupCity,
      dropoffRegion: f.dropoffRegion,
      dropoffCity: f.dropoffCity,
    ),
  ),
  _QuickGroup(
    label: 'Truck Type',
    options: ['FLATBED', 'BOX', 'REFRIGERATED', 'TANKER', 'LOWBED'],
    read: (f) => f.truckTypes,
    write: (f, v) => FreightFilter(
      cargoTypes: f.cargoTypes,
      truckTypes: v,
      pricingTypes: f.pricingTypes,
      statuses: f.statuses,
      pickupRegion: f.pickupRegion,
      pickupCity: f.pickupCity,
      dropoffRegion: f.dropoffRegion,
      dropoffCity: f.dropoffCity,
    ),
  ),
  _QuickGroup(
    label: 'Price',
    options: ['FIXED', 'NEGOTIABLE'],
    read: (f) => f.pricingTypes,
    write: (f, v) => FreightFilter(
      cargoTypes: f.cargoTypes,
      truckTypes: f.truckTypes,
      pricingTypes: v,
      statuses: f.statuses,
      pickupRegion: f.pickupRegion,
      pickupCity: f.pickupCity,
      dropoffRegion: f.dropoffRegion,
      dropoffCity: f.dropoffCity,
    ),
  ),
  _QuickGroup(
    label: 'Status',
    options: ['OPEN', 'BIDDING', 'BOOKED', 'COMPLETED', 'CANCELLED'],
    read: (f) => f.statuses,
    write: (f, v) => FreightFilter(
      cargoTypes: f.cargoTypes,
      truckTypes: f.truckTypes,
      pricingTypes: f.pricingTypes,
      statuses: v,
      pickupRegion: f.pickupRegion,
      pickupCity: f.pickupCity,
      dropoffRegion: f.dropoffRegion,
      dropoffCity: f.dropoffCity,
    ),
  ),
];

class _SearchAndFilterBar extends StatelessWidget {
  final TextEditingController controller;
  final FreightFilter activeFilter;
  final VoidCallback onAllFiltersTap;
  final VoidCallback onClearFilter;
  final ValueChanged<_QuickGroup> onQuickChipTap;

  const _SearchAndFilterBar({
    required this.controller,
    required this.activeFilter,
    required this.onAllFiltersTap,
    required this.onClearFilter,
    required this.onQuickChipTap,
  });

  int get _activeCount =>
      (activeFilter.cargoTypes?.length ?? 0) +
      (activeFilter.truckTypes?.length ?? 0) +
      (activeFilter.pricingTypes?.length ?? 0) +
      (activeFilter.statuses?.length ?? 0) +
      [
        activeFilter.pickupRegion,
        activeFilter.pickupCity,
        activeFilter.dropoffRegion,
        activeFilter.dropoffCity,
      ].where((v) => v != null).length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE4E4F4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Search by route, cargo, or city',
                hintStyle: context.text.bodyMedium?.copyWith(
                  color: context.appColors.textSecondary,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: context.appColors.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final group in _quickGroups) ...[
                  _QuickFilterChip(
                    group: group,
                    activeFilter: activeFilter,
                    onTap: () => onQuickChipTap(group),
                  ),
                  const SizedBox(width: 8),
                ],
                _AllFiltersChip(
                  activeCount: _activeCount,
                  onTap: onAllFiltersTap,
                ),
                if (!activeFilter.isEmpty) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onClearFilter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.close, size: 13, color: AppColors.error),
                          const SizedBox(width: 4),
                          Text(
                            'Clear',
                            style: context.text.bodySmall?.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _QuickFilterChip extends StatelessWidget {
  final _QuickGroup group;
  final FreightFilter activeFilter;
  final VoidCallback onTap;

  const _QuickFilterChip({
    required this.group,
    required this.activeFilter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = group.read(activeFilter);
    final count = selected?.length ?? 0;
    final isActive = count > 0;

    final label = !isActive
        ? group.label
        : count == 1
        ? '${group.label}: ${selected!.first}'
        : '${group.label} ($count)';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : const Color(0xFFDDDDEE),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: context.text.bodySmall?.copyWith(
                color: isActive ? Colors.white : context.appColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 14,
              color: isActive ? Colors.white : context.appColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _AllFiltersChip extends StatelessWidget {
  final int activeCount;
  final VoidCallback onTap;

  const _AllFiltersChip({required this.activeCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasActive = activeCount > 0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: hasActive
              ? AppColors.primary.withValues(alpha: 0.12)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hasActive ? AppColors.primary : const Color(0xFFDDDDEE),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.tune_rounded,
              size: 14,
              color: hasActive
                  ? AppColors.primary
                  : context.appColors.textPrimary,
            ),
            const SizedBox(width: 6),
            Text(
              hasActive ? 'All Filters ($activeCount)' : 'All Filters',
              style: context.text.bodySmall?.copyWith(
                color: hasActive
                    ? AppColors.primary
                    : context.appColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Single-field filter bottom sheet ────────────────────────────────────────

class _SingleFilterSheet extends StatefulWidget {
  final _QuickGroup group;
  final FreightFilter activeFilter;

  const _SingleFilterSheet({required this.group, required this.activeFilter});

  @override
  State<_SingleFilterSheet> createState() => _SingleFilterSheetState();
}

class _SingleFilterSheetState extends State<_SingleFilterSheet> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List<String>.from(widget.group.read(widget.activeFilter) ?? []);
  }

  void _toggle(String opt) => setState(() {
    _selected.contains(opt) ? _selected.remove(opt) : _selected.add(opt);
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDEE),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.group.label,
                style: context.text.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (_selected.isNotEmpty)
                TextButton(
                  onPressed: () => setState(() => _selected.clear()),
                  child: Text(
                    'Clear',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Select one or more',
            style: context.text.labelMedium?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.group.options.map((opt) {
              final isSelected = _selected.contains(opt);
              return GestureDetector(
                onTap: () => _toggle(opt),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : const Color(0xFFF0F0FA),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : const Color(0xFFDDDDEE),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        const Icon(Icons.check, size: 14, color: Colors.white),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        opt,
                        style: context.text.bodySmall?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : context.appColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(
                widget.group.write(
                  widget.activeFilter,
                  _selected.isEmpty ? null : List.unmodifiable(_selected),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                _selected.isEmpty ? 'Show All' : 'Apply (${_selected.length})',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty / Error / Footer ───────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  final bool hasFilter;
  final VoidCallback onClear;
  const _EmptyView({required this.hasFilter, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: context.appColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            hasFilter
                ? 'No freights match your filters'
                : 'No freights available',
            style: context.text.bodyMedium?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
          if (hasFilter) ...[
            const SizedBox(height: 12),
            TextButton(onPressed: onClear, child: const Text('Clear filters')),
          ],
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: context.appColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: context.text.bodyMedium?.copyWith(
              color: context.appColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _PaginationFooter extends StatelessWidget {
  final FreightListingSuccess state;
  const _PaginationFooter({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: FreightCardShimmer(),
      );
    }
    if (!state.hasMore) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            "You've reached the end",
            style: context.text.bodySmall?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
