import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/entity/my_carrier_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/presentation/bloc/my_carriers_bloc.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/presentation/bloc/my_carriers_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyCarriersScreen extends StatelessWidget {
  const MyCarriersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MyCarriersBloc>()..load(),
      child: const _MyCarriersView(),
    );
  }
}

class _MyCarriersView extends StatefulWidget {
  const _MyCarriersView();
  @override
  State<_MyCarriersView> createState() => _MyCarriersViewState();
}

class _MyCarriersViewState extends State<_MyCarriersView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  static const _tabs = ['Verified', 'Available', 'Pending'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<MyCarrierEntity> _filter(List<MyCarrierEntity> all, int i) {
    switch (i) {
      case 0:
        return all.where((c) => c.isVerified == true).toList();
      case 1:
        return all.where((c) => c.isAvailable == true).toList();
      case 2:
        return all.where((c) => c.isVerified == false).toList();
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'My Carriers',
          style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.pushNamed(context, Routes.registerCarrierStep1),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Register your carrier',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<MyCarriersBloc, MyCarriersState>(
        builder: (context, state) {
          if (state is MyCarriersLoading || state is MyCarriersInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MyCarriersError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.grey,
                  ),
                  const SizedBox(height: 12),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.read<MyCarriersBloc>().load(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is MyCarriersSuccess) {
            return TabBarView(
              controller: _tabController,
              children: List.generate(_tabs.length, (i) {
                final list = _filter(state.carriers, i);
                if (list.isEmpty) return _EmptyTab(tab: _tabs[i]);
                return RefreshIndicator(
                  onRefresh: () async => context.read<MyCarriersBloc>().load(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    itemCount: list.length,
                    itemBuilder: (_, idx) => _CarrierCard(carrier: list[idx]),
                  ),
                );
              }),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ─── Carrier Card — matches _buildCard() from CarrierListingScreen ───────────

class _CarrierCard extends StatelessWidget {
  final MyCarrierEntity carrier;
  const _CarrierCard({required this.carrier});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = isDark ? AppColorScheme.dark : AppColorScheme.light;
    final hasImage = carrier.images != null && carrier.images!.isNotEmpty;

    return InkWell(
      onTap: () {
        if (carrier.isVerified == false) {
          Navigator.pushNamed(
            context,
            Routes.carrierVerificationPending,
            arguments: carrier,
          );
        } else {
          Navigator.pushNamed(
            context,
            Routes.truckDetailRoute,
            arguments: carrier.id,
          );
        }
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
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(SizeManager.r16),
                bottomLeft: Radius.circular(SizeManager.r16),
              ),
              child: Container(
                width: 110,
                height: 110,
                color: cs.border,
                child: hasImage
                    ? Image.network(
                        carrier.images!.first,
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
            // Info
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
                            carrier.displayName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: cs.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _availabilityBadge(
                          carrier.isAvailable,
                          carrier.isVerified,
                          cs,
                        ),
                      ],
                    ),
                    const SizedBox(height: SizeManager.s4),
                    Text(
                      carrier.plateNumber ?? '—',
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
                            carrier.startLocation ?? '—',
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (carrier.loadCapacity != null) ...[
                          const SizedBox(width: SizeManager.s8),
                          Text(
                            '${carrier.loadCapacity!.toStringAsFixed(0)} kg',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
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

  Widget _availabilityBadge(
    bool? isAvailable,
    bool? isVerified,
    AppColorScheme cs,
  ) {
    final available = isAvailable ?? false;
    final verified = isVerified ?? false;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (verified) ...[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SizeManager.s8,
              vertical: SizeManager.s4,
            ),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(SizeManager.r4),
            ),
            child: const Text(
              'VERIFIED',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ] else ...[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SizeManager.s8,
              vertical: SizeManager.s4,
            ),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(SizeManager.r4),
            ),
            child: const Text(
              'PENDING',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.orange,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: SizeManager.s8,
            vertical: SizeManager.s4,
          ),
          decoration: BoxDecoration(
            color: available
                ? AppColors.success.withValues(alpha: 0.1)
                : cs.border,
            borderRadius: BorderRadius.circular(SizeManager.r4),
          ),
          child: Text(
            available ? 'AVAILABLE' : 'BUSY',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: available ? AppColors.success : cs.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _EmptyTab extends StatelessWidget {
  final String tab;
  const _EmptyTab({required this.tab});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.local_shipping_outlined,
          size: 48,
          color: AppColors.grey,
        ),
        const SizedBox(height: 12),
        Text(
          'No $tab carriers yet',
          style: context.text.bodyMedium?.copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
      ],
    ),
  );
}
