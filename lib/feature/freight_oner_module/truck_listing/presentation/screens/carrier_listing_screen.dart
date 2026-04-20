import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/screen/truck_detail_screen.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/presentation/widgets/carrier_card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/domain/entities/truck_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/domain/models/truck_filter.dart';
import '../bloc/region_bloc.dart';
import '../bloc/region_event.dart';
import '../bloc/region_state.dart';
import '../bloc/feature_bloc.dart';
import '../bloc/feature_event.dart';
import '../bloc/feature_state.dart';
import '../bloc/brand_bloc.dart';
import '../bloc/brand_event.dart';
import '../bloc/brand_state.dart';
import '../bloc/truck_bloc.dart';
import '../bloc/truck_event.dart';
import '../bloc/truck_state.dart';

class CarrierListingScreen extends StatefulWidget {
  const CarrierListingScreen({super.key});

  @override
  State<CarrierListingScreen> createState() => _CarrierListingScreenState();
}

class _CarrierListingScreenState extends State<CarrierListingScreen> {
  late ScrollController _scrollController;
  late TextEditingController _searchController;

  // Local UI state — mirrors what's been sent to the bloc
  TruckFilter _activeFilter = const TruckFilter();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    context.read<TruckBloc>().add(FetchInitialTrucks());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<TruckBloc>().add(FetchNextPage());
    }
  }

  void _applyFilter(TruckFilter filter) {
    setState(() => _activeFilter = filter);
    context.read<TruckBloc>().add(ApplyTruckFilter(filter));
  }

  void _resetFilters() {
    setState(() => _activeFilter = const TruckFilter());
    context.read<TruckBloc>().add(ResetTruckFilters());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = isDark ? AppColorScheme.dark : AppColorScheme.light;

    return Scaffold(
      backgroundColor: cs.background,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40),
            // _buildAppBar(cs),
            _buildSearchBar(cs),
            _buildFilterChips(cs),
            Expanded(child: _buildList(cs)),
          ],
        ),
      ),
    );
  }

  // ── App bar ───────────────────────────────────────────────────────────────

  // Widget _buildAppBar(AppColorScheme cs) {
  //   return Container(
  //     padding: const EdgeInsets.all(SizeManager.s16),
  //     child: Row(
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(SizeManager.s12),
  //           decoration: BoxDecoration(
  //             color: AppColors.primary,
  //             borderRadius: BorderRadius.circular(SizeManager.r12),
  //           ),
  //           child: const Icon(
  //             Icons.local_shipping,
  //             color: AppColors.white,
  //             size: 24,
  //           ),
  //         ),
  //         const SizedBox(width: SizeManager.s12),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'FreightConnect',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: cs.textPrimary,
  //               ),
  //             ),
  //             Text(
  //               'AVAILABLE TRUCKS',
  //               style: TextStyle(
  //                 fontSize: 10,
  //                 color: cs.textSecondary,
  //                 letterSpacing: 1.2,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const Spacer(),
  //         IconButton(
  //           onPressed: () {},
  //           icon: Icon(Icons.notifications_outlined, color: cs.textPrimary),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // ── Search bar ────────────────────────────────────────────────────────────

  Widget _buildSearchBar(AppColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
      child: TextField(
        controller: _searchController,
        style: TextStyle(fontSize: 14, color: cs.textPrimary),
        onSubmitted: (value) {
          _applyFilter(
            _activeFilter.copyWith(
              search: value.isEmpty ? null : value,
              clearSearch: value.isEmpty,
              page: 1,
            ),
          );
        },
        decoration: InputDecoration(
          hintText: 'Search carrier or model...',
          hintStyle: TextStyle(fontSize: 14, color: cs.textSecondary),
          prefixIcon: Icon(Icons.search, size: 20, color: cs.textSecondary),
          filled: true,
          fillColor: cs.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SizeManager.r12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: SizeManager.s12,
            vertical: SizeManager.s12,
          ),
        ),
      ),
    );
  }

  // ── Filter chips ──────────────────────────────────────────────────────────

  Widget _buildFilterChips(AppColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: SizeManager.s16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
        child: Row(
          children: [
            _chip(
              label: 'All',
              isSelected: !_activeFilter.hasActiveFilters,
              onTap: _resetFilters,
              cs: cs,
            ),
            const SizedBox(width: SizeManager.s8),
            _chip(
              label: 'Feature',
              isSelected: _activeFilter.features != null,
              hasDropdown: true,
              onTap: () => _showFeatureSheet(cs),
              cs: cs,
            ),
            const SizedBox(width: SizeManager.s8),
            _chip(
              label: 'Brand',
              isSelected: _activeFilter.brand != null,
              hasDropdown: true,
              onTap: () => _showBrandSheet(cs),
              cs: cs,
            ),
            const SizedBox(width: SizeManager.s8),
            _chip(
              label: 'Region',
              isSelected: _activeFilter.region != null,
              hasDropdown: true,
              onTap: () => _showRegionSheet(cs),
              cs: cs,
            ),
            const SizedBox(width: SizeManager.s8),
            _chip(
              label: 'Verification',
              isSelected: _activeFilter.isVerified != null,
              hasDropdown: true,
              onTap: () => _showVerificationSheet(cs),
              cs: cs,
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required AppColorScheme cs,
    bool hasDropdown = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SizeManager.s16,
          vertical: SizeManager.s10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : cs.surface,
          borderRadius: BorderRadius.circular(SizeManager.r20),
          border: Border.all(color: isSelected ? AppColors.primary : cs.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.white : cs.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            if (hasDropdown) ...[
              const SizedBox(width: SizeManager.s4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: isSelected ? AppColors.white : cs.textPrimary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Truck list ────────────────────────────────────────────────────────────

  Widget _buildList(AppColorScheme cs) {
    return BlocBuilder<TruckBloc, TruckState>(
      builder: (context, state) {
        if (state is TruckInitial || state is TruckLoading) {
          return Center(
            child: CarrierCardLoadingWidget(),
          );
        }

        if (state is TruckError) {
          return _errorView(
            state.message,
            cs,
            onRetry: () => context.read<TruckBloc>().add(FetchInitialTrucks()),
          );
        }

        List<TruckEntity> trucks = [];
        bool hasMore = false;
        bool isPaginating = false;
        bool isPaginationError = false;
        String paginationMsg = '';

        if (state is TruckSuccess) {
          trucks = state.trucks.trucks ?? [];
          hasMore = state.hasMorePages;
        } else if (state is TruckPaginationLoading) {
          trucks = state.currentTrucks.trucks ?? [];
          isPaginating = true;
        } else if (state is TruckPaginationError) {
          trucks = state.currentTrucks.trucks ?? [];
          isPaginationError = true;
          paginationMsg = state.message;
        }

        if (trucks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_shipping_outlined,
                  size: 64,
                  color: cs.textSecondary,
                ),
                const SizedBox(height: SizeManager.s16),
                Text(
                  _activeFilter.hasActiveFilters
                      ? 'No carriers match your filters'
                      : 'No carriers available',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: cs.textPrimary,
                  ),
                ),
                if (_activeFilter.hasActiveFilters) ...[
                  const SizedBox(height: SizeManager.s8),
                  TextButton(
                    onPressed: _resetFilters,
                    child: const Text(
                      'Clear all filters',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ],
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(SizeManager.s16),
          itemCount: trucks.length + 1,
          itemBuilder: (context, index) {
            if (index == trucks.length) {
              if (isPaginating) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeManager.s24),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
                );
              }
              if (isPaginationError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: SizeManager.s16,
                    horizontal: SizeManager.s24,
                  ),
                  child: Column(
                    children: [
                      Text(
                        paginationMsg,
                        style: TextStyle(fontSize: 13, color: cs.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () =>
                            context.read<TruckBloc>().add(FetchNextPage()),
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (!hasMore) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: SizeManager.s24,
                  ),
                  child: Center(
                    child: Text(
                      'No more carriers',
                      style: TextStyle(fontSize: 13, color: cs.textSecondary),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }
            return _buildCard(trucks[index], cs);
          },
        );
      },
    );
  }

  // ── Carrier card ──────────────────────────────────────────────────────────
  Widget _buildCard(TruckEntity truck, AppColorScheme cs) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.truckDetailRoute,
          arguments: truck.id,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: SizeManager.s16),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(SizeManager.r16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(SizeManager.r16),
                bottomLeft: Radius.circular(SizeManager.r16),
              ),
              child: Container(
                width: 110,
                height: 110,
                color: cs.border,
                child: truck.images.isNotEmpty
                    ? Image.network(
                        truck.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.local_shipping,
                          size: 40,
                          color: cs.textSecondary,
                        ),
                      )
                    : Icon(
                        Icons.local_shipping,
                        size: 40,
                        color: cs.textSecondary,
                      ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(SizeManager.s12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${truck.brand} ${truck.model}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: cs.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _availabilityBadge(truck.isAvailable, cs),
                      ],
                    ),
                    const SizedBox(height: SizeManager.s4),
                    Text(
                      truck.plateNumber,
                      style: TextStyle(fontSize: 13, color: cs.textSecondary),
                    ),
                    const SizedBox(height: SizeManager.s8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: cs.textSecondary,
                        ),
                        const SizedBox(width: SizeManager.s4),
                        Expanded(
                          child: Text(
                            truck.location,
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: SizeManager.s8),
                        Text(
                          '\$${truck.pricePerKm.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '/km',
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _availabilityBadge(bool isAvailable, AppColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SizeManager.s8,
        vertical: SizeManager.s4,
      ),
      decoration: BoxDecoration(
        color: isAvailable
            ? AppColors.success.withValues(alpha: 0.1)
            : cs.border,
        borderRadius: BorderRadius.circular(SizeManager.r4),
      ),
      child: Text(
        isAvailable ? 'AVAILABLE' : 'BUSY',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isAvailable ? AppColors.success : cs.textSecondary,
        ),
      ),
    );
  }

  Widget _errorView(
    String message,
    AppColorScheme cs, {
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SizeManager.s24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: cs.textSecondary),
            const SizedBox(height: SizeManager.s16),
            Text(
              'Failed to load carriers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: cs.textPrimary,
              ),
            ),
            const SizedBox(height: SizeManager.s8),
            Text(
              message,
              style: TextStyle(fontSize: 14, color: cs.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SizeManager.s24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: SizeManager.s24,
                  vertical: SizeManager.s12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeManager.r12),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom sheets ─────────────────────────────────────────────────────────

  void _showFeatureSheet(AppColorScheme cs) {
    context.read<FeatureBloc>().add(FetchFeatures());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FeatureSheet(
        cs: cs,
        selected: _activeFilter.features,
        onApply: (value) => _applyFilter(
          _activeFilter.copyWith(
            features: value,
            clearFeature: value == null,
            page: 1,
          ),
        ),
      ),
    );
  }

  void _showBrandSheet(AppColorScheme cs) {
    context.read<BrandBloc>().add(FetchBrands());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BrandSheet(
        cs: cs,
        selected: _activeFilter.brand,
        onApply: (value) => _applyFilter(
          _activeFilter.copyWith(
            brand: value,
            clearBrand: value == null,
            page: 1,
          ),
        ),
      ),
    );
  }

  void _showRegionSheet(AppColorScheme cs) {
    context.read<RegionBloc>().add(FetchRegions());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RegionSheet(
        cs: cs,
        selected: _activeFilter.region,
        onApply: (value) => _applyFilter(
          _activeFilter.copyWith(
            region: value,
            clearRegion: value == null,
            page: 1,
          ),
        ),
      ),
    );
  }

  void _showVerificationSheet(AppColorScheme cs) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _VerificationSheet(
        cs: cs,
        selected: _activeFilter.isVerified,
        onApply: (value) {
          _applyFilter(
            _activeFilter.copyWith(
              isVerified: value,
              clearIsVerified: value == null,
              page: 1,
            ),
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}
// ── Shared bottom sheet scaffold ──────────────────────────────────────────

class _SheetScaffold extends StatelessWidget {
  final AppColorScheme cs;
  final String title;
  final String subtitle;
  final Widget body;
  final Widget footer;

  const _SheetScaffold({
    required this.cs,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(SizeManager.r24),
          topRight: Radius.circular(SizeManager.r24),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: SizeManager.s12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: cs.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: SizeManager.s24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SizeManager.s24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                  ),
                ),
                const SizedBox(height: SizeManager.s8),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: cs.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: SizeManager.s16),
          Expanded(child: body),
          footer,
        ],
      ),
    );
  }
}

Widget _applyButton(AppColorScheme cs, String label, VoidCallback onPressed) {
  return Container(
    padding: const EdgeInsets.all(SizeManager.s24),
    decoration: BoxDecoration(
      color: cs.surface,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: SizeManager.s16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeManager.r12),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}

Widget _searchField(
  AppColorScheme cs,
  String hint,
  ValueChanged<String> onChanged,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: SizeManager.s24),
    child: TextField(
      onChanged: onChanged,
      style: TextStyle(fontSize: 14, color: cs.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14, color: cs.textSecondary),
        prefixIcon: Icon(Icons.search, size: 20, color: cs.textSecondary),
        filled: true,
        fillColor: cs.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeManager.r12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SizeManager.s12,
          vertical: SizeManager.s12,
        ),
      ),
    ),
  );
}

Widget _radioTile<T>(
  AppColorScheme cs,
  String label,
  T value,
  T? selected,
  ValueChanged<T?> onChanged,
) {
  final isSelected = selected == value;
  return InkWell(
    onTap: () => onChanged(isSelected ? null : value),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: SizeManager.s16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: cs.border, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: cs.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.primary : Colors.transparent,
              border: Border.all(
                color: isSelected ? AppColors.primary : cs.border,
                width: 2,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, size: 16, color: AppColors.white)
                : null,
          ),
        ],
      ),
    ),
  );
}

// ── Feature sheet ─────────────────────────────────────────────────────────

class _FeatureSheet extends StatefulWidget {
  final AppColorScheme cs;
  final String? selected;
  final ValueChanged<String?> onApply;

  const _FeatureSheet({
    required this.cs,
    required this.selected,
    required this.onApply,
  });

  @override
  State<_FeatureSheet> createState() => _FeatureSheetState();
}

class _FeatureSheetState extends State<_FeatureSheet> {
  String? _temp;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _temp = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      cs: widget.cs,
      title: 'Select Feature',
      subtitle: 'Filter carriers by feature',
      body: Column(
        children: [
          _searchField(
            widget.cs,
            'Search feature...',
            (v) => setState(() => _query = v),
          ),
          const SizedBox(height: SizeManager.s8),
          Expanded(
            child: BlocBuilder<FeatureBloc, FeatureState>(
              builder: (context, state) {
                if (state is FeatureLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                if (state is FeatureError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: widget.cs.textSecondary),
                    ),
                  );
                }
                if (state is FeatureSuccess) {
                  final items = (state.features.features ?? [])
                      .where(
                        (f) =>
                            f.name.toLowerCase().contains(_query.toLowerCase()),
                      )
                      .toList();
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SizeManager.s24,
                    ),
                    itemCount: items.length,
                    itemBuilder: (_, i) => _radioTile<String>(
                      widget.cs,
                      items[i].name,
                      items[i].name,
                      _temp,
                      (v) => setState(() => _temp = v),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      footer: _applyButton(
        widget.cs,
        _temp == null ? 'Clear Filter' : 'Apply',
        () {
          widget.onApply(_temp);
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ── Brand sheet ───────────────────────────────────────────────────────────

class _BrandSheet extends StatefulWidget {
  final AppColorScheme cs;
  final String? selected;
  final ValueChanged<String?> onApply;

  const _BrandSheet({
    required this.cs,
    required this.selected,
    required this.onApply,
  });

  @override
  State<_BrandSheet> createState() => _BrandSheetState();
}

class _BrandSheetState extends State<_BrandSheet> {
  String? _temp;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _temp = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      cs: widget.cs,
      title: 'Select Brand',
      subtitle: 'Filter carriers by brand',
      body: Column(
        children: [
          _searchField(
            widget.cs,
            'Search brand...',
            (v) => setState(() => _query = v),
          ),
          const SizedBox(height: SizeManager.s8),
          Expanded(
            child: BlocBuilder<BrandBloc, BrandState>(
              builder: (context, state) {
                if (state is BrandLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                if (state is BrandError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: widget.cs.textSecondary),
                    ),
                  );
                }
                if (state is BrandSuccess) {
                  final items = (state.brands.brands ?? [])
                      .where(
                        (b) =>
                            b.name.toLowerCase().contains(_query.toLowerCase()),
                      )
                      .toList();
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SizeManager.s24,
                    ),
                    itemCount: items.length,
                    itemBuilder: (_, i) => _radioTile<String>(
                      widget.cs,
                      items[i].name,
                      items[i].name,
                      _temp,
                      (v) => setState(() => _temp = v),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      footer: _applyButton(
        widget.cs,
        _temp == null ? 'Clear Filter' : 'Apply',
        () {
          widget.onApply(_temp);
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ── Region sheet ──────────────────────────────────────────────────────────

class _RegionSheet extends StatefulWidget {
  final AppColorScheme cs;
  final String? selected;
  final ValueChanged<String?> onApply;

  const _RegionSheet({
    required this.cs,
    required this.selected,
    required this.onApply,
  });

  @override
  State<_RegionSheet> createState() => _RegionSheetState();
}

class _RegionSheetState extends State<_RegionSheet> {
  String? _temp;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _temp = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      cs: widget.cs,
      title: 'Select Region',
      subtitle: 'Filter carriers by region',
      body: Column(
        children: [
          _searchField(
            widget.cs,
            'Search region...',
            (v) => setState(() => _query = v),
          ),
          const SizedBox(height: SizeManager.s8),
          Expanded(
            child: BlocBuilder<RegionBloc, RegionState>(
              builder: (context, state) {
                if (state is RegionLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                if (state is RegionError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: widget.cs.textSecondary),
                    ),
                  );
                }
                if (state is RegionSuccess) {
                  final items = (state.regions.regions ?? [])
                      .where(
                        (r) =>
                            r.name.toLowerCase().contains(_query.toLowerCase()),
                      )
                      .toList();
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SizeManager.s24,
                    ),
                    itemCount: items.length,
                    itemBuilder: (_, i) => _radioTile<String>(
                      widget.cs,
                      items[i].name,
                      items[i].name,
                      _temp,
                      (v) => setState(() => _temp = v),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      footer: _applyButton(
        widget.cs,
        _temp == null ? 'Clear Filter' : 'Apply',
        () {
          widget.onApply(_temp);
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ── Verification sheet ────────────────────────────────────────────────────

class _VerificationSheet extends StatelessWidget {
  final AppColorScheme cs;
  final bool? selected;
  final ValueChanged<bool?> onApply;

  const _VerificationSheet({
    required this.cs,
    required this.selected,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      cs: cs,
      title: 'Verification',
      subtitle: 'Filter by carrier verification status',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SizeManager.s24),
        child: Column(
          children: [
            _radioTile<bool?>(cs, 'Both (All)', null, selected, onApply),
            _radioTile<bool?>(cs, 'Verified', true, selected, onApply),
            _radioTile<bool?>(cs, 'Not Verified', false, selected, onApply),
          ],
        ),
      ),
      footer: const SizedBox.shrink(),
    );
  }
}
