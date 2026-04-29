import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/entity/driver_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/presentation/bloc/driver_bloc.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/presentation/bloc/driver_event.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/presentation/bloc/driver_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverListScreen extends StatelessWidget {
  const DriverListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DriverBloc>()..add(const LoadMyDrivers()),
      child: const _DriverListView(),
    );
  }
}

class _DriverListView extends StatelessWidget {
  const _DriverListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Drivers',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(
          context,
          Routes.createDriverScreen,
        ).then((_) => context.read<DriverBloc>().add(const LoadMyDrivers())),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Driver',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<DriverBloc, DriverState>(
        builder: (context, state) {
          if (state is DriverLoading || state is DriverInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DriverError) {
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
                    onPressed: () =>
                        context.read<DriverBloc>().add(const LoadMyDrivers()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is DriverListLoaded) {
            if (state.drivers.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_outline, size: 48, color: AppColors.grey),
                    SizedBox(height: 12),
                    Text('No drivers yet. Add your first driver.'),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<DriverBloc>().add(const LoadMyDrivers()),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: state.drivers.length,
                itemBuilder: (_, i) => _DriverCard(driver: state.drivers[i]),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _DriverCard extends StatelessWidget {
  final DriverEntity driver;
  const _DriverCard({required this.driver});

  @override
  Widget build(BuildContext context) {
    final fullName = '${driver.firstName ?? ''} ${driver.lastName ?? ''}'
        .trim();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: const Icon(Icons.person, color: AppColors.primary),
        ),
        title: Text(
          fullName.isEmpty ? 'Unknown Driver' : fullName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (driver.licenseNumber != null)
              Text(
                'License: ${driver.licenseNumber}',
                style: const TextStyle(fontSize: 12),
              ),
            if (driver.assignedCarrierName != null)
              Text(
                'Carrier: ${driver.assignedCarrierName}',
                style: const TextStyle(fontSize: 12, color: AppColors.primary),
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.pushNamed(
          context,
          Routes.driverDetailScreen,
          arguments: driver,
        ).then((_) => context.read<DriverBloc>().add(const LoadMyDrivers())),
      ),
    );
  }
}
