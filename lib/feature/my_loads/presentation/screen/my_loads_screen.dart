import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/feature/freight/presentation/screen/freight_detail_page.dart';
import 'package:clean_architecture/feature/my_loads/presentation/bloc/my_loads_bloc.dart';
import 'package:clean_architecture/feature/my_loads/presentation/bloc/my_loads_event.dart';
import 'package:clean_architecture/feature/my_loads/presentation/bloc/my_loads_state.dart';
import 'package:clean_architecture/feature/my_loads/presentation/model/load_view_model.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/widgets/carrier_card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _tabStatuses = ['OPEN', 'BIDDING', 'BOOKED', 'COMPLETED', 'CANCELLED'];
const _tabLabels = ['OPEN', 'BIDDING', 'BOOKED', 'COMPLETED', 'CANCELLED'];

class MyLoadsScreen extends StatefulWidget {
  const MyLoadsScreen({super.key});

  @override
  State<MyLoadsScreen> createState() => _MyLoadsScreenState();
}

class _MyLoadsScreenState extends State<MyLoadsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _searchActive = false;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabStatuses.length, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    _clearSearch();
    context.read<MyLoadsBloc>().add(
      FetchMyLoads(_tabStatuses[_tabController.index]),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _query = '';
      _searchActive = false;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  AppColorScheme get _cs {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColorScheme.dark : AppColorScheme.light;
  }

  @override
  Widget build(BuildContext context) {
    final cs = _cs;
    return Scaffold(
      backgroundColor: cs.background,
      body: Column(
        children: [
          _MyLoadsHeader(
            cs: cs,
            tabController: _tabController,
            searchActive: _searchActive,
            searchController: _searchController,
            query: _query,
            onSearchToggle: () => setState(() {
              _searchActive = !_searchActive;
              if (!_searchActive) {
                _searchController.clear();
                _query = '';
              }
            }),
            onQueryChanged: (v) => setState(() => _query = v),
            onSearchClear: _clearSearch,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabStatuses
                  .map((s) => _TabContent(status: s, cs: cs, query: _query))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, Routes.postFreightRoute),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white, size: 28),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────

class _MyLoadsHeader extends StatelessWidget {
  final AppColorScheme cs;
  final TabController tabController;
  final bool searchActive;
  final TextEditingController searchController;
  final String query;
  final VoidCallback onSearchToggle;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onSearchClear;

  const _MyLoadsHeader({
    required this.cs,
    required this.tabController,
    required this.searchActive,
    required this.searchController,
    required this.query,
    required this.onSearchToggle,
    required this.onQueryChanged,
    required this.onSearchClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cs.surface,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SizeManager.s16,
                SizeManager.s12,
                SizeManager.s4,
                0,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: searchActive
                    ? _SearchBar(
                        key: const ValueKey('search'),
                        cs: cs,
                        controller: searchController,
                        onChanged: onQueryChanged,
                        onClear: onSearchClear,
                      )
                    : Row(
                        key: const ValueKey('title'),
                        children: [
                          Text(
                            'My Loads',
                            style: TextStyle(
                              color: cs.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.search,
                              color: cs.textPrimary,
                              size: 22,
                            ),
                            onPressed: onSearchToggle,
                          ),
                        ],
                      ),
              ),
            ),
            TabBar(
              controller: tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: AppColors.primary,
              unselectedLabelColor: cs.textSecondary,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
              tabs: _tabLabels.map((l) => Tab(text: l)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final AppColorScheme cs;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    super.key,
    required this.cs,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: cs.background,
              borderRadius: BorderRadius.circular(SizeManager.r12),
              border: Border.all(color: cs.border),
            ),
            child: TextField(
              controller: controller,
              autofocus: true,
              onChanged: onChanged,
              style: TextStyle(fontSize: 14, color: cs.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search by city, truck type...',
                hintStyle: TextStyle(fontSize: 13, color: cs.textSecondary),
                prefixIcon: Icon(
                  Icons.search,
                  size: 18,
                  color: cs.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: onClear,
          child: Text(
            'Cancel',
            style: TextStyle(color: cs.primary, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

// ── Tab content ───────────────────────────────────────────────────────────

class _TabContent extends StatelessWidget {
  final String status;
  final AppColorScheme cs;
  final String query;

  const _TabContent({
    required this.status,
    required this.cs,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyLoadsBloc, MyLoadsState>(
      builder: (context, state) {
        if (state is MyLoadsLoading) {
          return const Center(child: CarrierCardLoadingWidget());
        }
        if (state is MyLoadsError) {
          return _ErrorState(
            message: state.message,
            cs: cs,
            onRetry: () =>
                context.read<MyLoadsBloc>().add(FetchMyLoads(status)),
          );
        }
        if (state is MyLoadsSuccess) {
          final q = query.trim().toLowerCase();
          final all = state.freights.map(LoadViewModel.from).toList();
          final items = q.isEmpty
              ? all
              : all.where((vm) {
                  return vm.pickupCity.toLowerCase().contains(q) ||
                      vm.dropoffCity.toLowerCase().contains(q) ||
                      vm.truckType.toLowerCase().contains(q);
                }).toList();

          if (items.isEmpty) {
            return _EmptyState(
              status: LoadViewModel.fromStatusString(status),
              cs: cs,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              SizeManager.s16,
              SizeManager.s16,
              SizeManager.s16,
              100,
            ),
            itemCount: items.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: SizeManager.s12),
            itemBuilder: (_, i) => _LoadCard(vm: items[i], cs: cs),
          );
        }
        return _EmptyState(
          status: LoadViewModel.fromStatusString(status),
          cs: cs,
        );
      },
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final LoadStatus status;
  final AppColorScheme cs;

  const _EmptyState({required this.status, required this.cs});

  @override
  Widget build(BuildContext context) {
    final label = status.name.toLowerCase();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: cs.border, shape: BoxShape.circle),
            child: Icon(
              LoadViewModel.emptyIcon(status),
              size: 36,
              color: cs.textSecondary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: SizeManager.s16),
          Text(
            'No $label loads',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: cs.textPrimary,
            ),
          ),
          const SizedBox(height: SizeManager.s8),
          Text(
            'Your $label loads will appear here',
            style: TextStyle(fontSize: 14, color: cs.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ── Error state ───────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String message;
  final AppColorScheme cs;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.cs,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: SizeManager.s16),
          Text(
            message,
            style: TextStyle(fontSize: 14, color: cs.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SizeManager.s16),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

// ── Load card ─────────────────────────────────────────────────────────────

class _LoadCard extends StatelessWidget {
  final LoadViewModel vm;
  final AppColorScheme cs;

  const _LoadCard({required this.vm, required this.cs});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FreightDetailPage(freightId: vm.freightId),
          ),
        );
      },
      child: Container(
        height: 135,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(SizeManager.r12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SizeManager.r12),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                height: 140,
                child: vm.imageUrl != null
                    ? Image.network(
                        vm.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _Placeholder(cs: cs),
                      )
                    : _Placeholder(cs: cs),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(SizeManager.s12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          _StatusBadge(
                            label: vm.statusLabel,
                            color: vm.statusColor,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _RouteRow(
                            city: vm.pickupCity,
                            dotColor: const Color(0xFFFF6B00),
                            cs: cs,
                          ),
                          const SizedBox(height: SizeManager.s4),
                          _RouteRow(
                            city: vm.dropoffCity,
                            dotColor: cs.textSecondary,
                            cs: cs,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'TRUCK: ${vm.truckType}',
                            style: TextStyle(
                              fontSize: 11,
                              color: cs.textSecondary,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                vm.priceLabel,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: cs.textSecondary,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                vm.priceValue,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: cs.textPrimary,
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

// ── Shared small widgets ──────────────────────────────────────────────────

class _Placeholder extends StatelessWidget {
  final AppColorScheme cs;
  const _Placeholder({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cs.border,
      child: Center(
        child: Icon(
          Icons.inventory_2_outlined,
          size: 36,
          color: cs.textSecondary,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(SizeManager.r4),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _RouteRow extends StatelessWidget {
  final String city;
  final Color dotColor;
  final AppColorScheme cs;
  const _RouteRow({
    required this.city,
    required this.dotColor,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: SizeManager.s8),
        Expanded(
          child: Text(
            city,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: cs.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
