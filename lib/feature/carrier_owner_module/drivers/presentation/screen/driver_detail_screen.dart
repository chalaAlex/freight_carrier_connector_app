import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/entity/my_carrier_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/usecase/get_my_carriers_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/entity/driver_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/presentation/bloc/driver_bloc.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/presentation/bloc/driver_event.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/presentation/bloc/driver_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DriverDetailScreen extends StatelessWidget {
  final DriverEntity driver;
  const DriverDetailScreen({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DriverBloc>(),
      child: _DriverDetailView(driver: driver),
    );
  }
}

class _DriverDetailView extends StatelessWidget {
  final DriverEntity driver;
  const _DriverDetailView({required this.driver});

  Future<void> _showAssignSheet(BuildContext context) async {
    final useCase = sl<GetMyCarriersUseCase>();
    final result = await useCase();
    if (!context.mounted) return;

    result.fold(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (response) {
        final carriers = response.carriers ?? [];
        showModalBottomSheet(
          context: context,
          builder: (_) => _AssignCarrierSheet(
            carriers: carriers,
            onSelect: (carrierId) {
              Navigator.pop(context);
              context.read<DriverBloc>().add(
                AssignDriver(carrierId: carrierId, driverId: driver.id),
              );
            },
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Driver'),
        content: const Text(
          'Are you sure you want to delete this driver? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<DriverBloc>().add(DeleteDriver(driver.id));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fullName = '${driver.firstName ?? ''} ${driver.lastName ?? ''}'
        .trim();

    return BlocListener<DriverBloc, DriverState>(
      listener: (context, state) {
        if (state is DriverSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          if (state.message.contains('deleted')) {
            Navigator.pop(context);
          }
        } else if (state is DriverError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(fullName.isEmpty ? 'Driver Details' : fullName),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.pushNamed(
                context,
                Routes.editDriverScreen,
                arguments: driver,
              ),
            ),
          ],
        ),
        body: BlocBuilder<DriverBloc, DriverState>(
          builder: (context, state) {
            if (state is DriverLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // License image
                  if (driver.licenseImageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        driver.licenseImageUrl!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 180,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  _InfoTile(label: 'Full Name', value: fullName),
                  _InfoTile(label: 'Email', value: driver.email),
                  _InfoTile(label: 'Phone', value: driver.phone),
                  _InfoTile(
                    label: 'License Number',
                    value: driver.licenseNumber,
                  ),
                  _InfoTile(
                    label: 'License Expiry',
                    value: driver.licenseExpiry != null
                        ? DateFormat('yyyy-MM-dd').format(driver.licenseExpiry!)
                        : null,
                  ),
                  _InfoTile(
                    label: 'Assigned Carrier',
                    value: driver.assignedCarrierName ?? 'Not assigned',
                  ),
                  const SizedBox(height: 24),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showAssignSheet(context),
                          icon: const Icon(Icons.link),
                          label: const Text('Assign'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: driver.assignedCarrierId == null
                              ? null
                              : () => context.read<DriverBloc>().add(
                                  UnassignDriver(
                                    carrierId: driver.assignedCarrierId!,
                                    driverId: driver.id,
                                  ),
                                ),
                          icon: const Icon(Icons.link_off),
                          label: const Text('Unassign'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orange,
                            side: const BorderSide(color: Colors.orange),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _confirmDelete(context),
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete Driver'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String? value;
  const _InfoTile({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '—',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssignCarrierSheet extends StatelessWidget {
  final List<MyCarrierEntity> carriers;
  final void Function(String carrierId) onSelect;
  const _AssignCarrierSheet({required this.carriers, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Select a Carrier',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        const Divider(height: 1),
        if (carriers.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text('No carriers available'),
          )
        else
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: carriers.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 80),
              itemBuilder: (_, i) {
                final c = carriers[i];
                final imageUrl = (c.images != null && c.images!.isNotEmpty)
                    ? c.images!.first
                    : null;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholderIcon(),
                          )
                        : _placeholderIcon(),
                  ),
                  title: Text(
                    c.displayName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (c.plateNumber != null)
                        Text(
                          c.plateNumber!,
                          style: const TextStyle(fontSize: 12),
                        ),
                      if (c.loadCapacity != null)
                        Text(
                          '${c.loadCapacity!.toStringAsFixed(0)} kg capacity',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => onSelect(c.id),
                );
              },
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _placeholderIcon() => Container(
    width: 56,
    height: 56,
    decoration: BoxDecoration(
      color: AppColors.primary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.local_shipping, color: AppColors.primary),
  );
}
