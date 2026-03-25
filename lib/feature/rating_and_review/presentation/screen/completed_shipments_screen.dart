import 'package:clean_architecture/feature/rating_and_review/domain/entity/review_entity.dart';
import 'package:clean_architecture/feature/rating_and_review/presentation/bloc/completed_shipments_bloc.dart';
import 'package:clean_architecture/feature/rating_and_review/presentation/screen/submit_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompletedShipmentsScreen extends StatefulWidget {
  const CompletedShipmentsScreen({super.key});

  @override
  State<CompletedShipmentsScreen> createState() =>
      _CompletedShipmentsScreenState();
}

class _CompletedShipmentsScreenState extends State<CompletedShipmentsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CompletedShipmentsBloc>().add(const LoadCompletedShipments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Your Shipments')),
      body: BlocBuilder<CompletedShipmentsBloc, CompletedShipmentsState>(
        builder: (context, state) {
          if (state is CompletedShipmentsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CompletedShipmentsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (state is CompletedShipmentsLoaded) {
            if (state.shipments.isEmpty) {
              return const Center(
                child: Text('No completed shipments to review.'),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.shipments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final shipment = state.shipments[index];
                return _ShipmentCard(shipment: shipment);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ShipmentCard extends StatelessWidget {
  final CompletedShipmentEntity shipment;

  const _ShipmentCard({required this.shipment});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.local_shipping_outlined),
        title: Text(
          [
            shipment.carrierBrand,
            shipment.carrierModel,
          ].where((s) => s != null && s.isNotEmpty).join(' '),
        ),
        subtitle: Text(shipment.plateNumber ?? ''),
        trailing: const Icon(Icons.star_rate_outlined),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubmitReviewScreen(shipment: shipment),
            ),
          );
          // Refresh list after returning
          if (context.mounted) {
            context.read<CompletedShipmentsBloc>().add(
              const LoadCompletedShipments(),
            );
          }
        },
      ),
    );
  }
}
