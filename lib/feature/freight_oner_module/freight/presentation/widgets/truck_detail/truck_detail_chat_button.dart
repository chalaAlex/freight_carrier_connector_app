import 'package:clean_architecture/feature/freight_oner_module/shipment_request/presentation/screen/create_shipment_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/feature/chat/domain/usecases/get_or_create_room_usecase.dart';
import 'package:clean_architecture/feature/chat/presentation/screens/chat_room_screen.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/entity/truck_detail_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/domain/entities/truck_entity.dart'
    as listing;

class TruckDetailChatButton extends StatefulWidget {
  final TruckEntity? truck;

  const TruckDetailChatButton({super.key, this.truck});

  @override
  State<TruckDetailChatButton> createState() => _TruckDetailChatButtonState();
}

class _TruckDetailChatButtonState extends State<TruckDetailChatButton> {
  bool _isLoading = false;

  Future<void> _connectOwner() async {
    final ownerId = widget.truck?.truckOwner?.id;
    final firstName = widget.truck?.truckOwner?.firstName ?? '';
    final lastName = widget.truck?.truckOwner?.lastName ?? '';
    final ownerName = '$firstName $lastName'.trim();

    if (ownerId == null || ownerId.isEmpty) return;

    setState(() => _isLoading = true);

    final result = await sl<GetOrCreateRoomUseCase>()(ownerId);

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (room) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatRoomScreen(
            roomId: room.id,
            otherParticipantName: ownerName.isEmpty ? 'Owner' : ownerName,
          ),
        ),
      ),
    );
  }

  void _bookRequest() {
    final truck = widget.truck;
    if (truck == null) return;
    final listingTruck = listing.TruckEntity(
      id: truck.id ?? '',
      model: truck.model ?? '',
      plateNumber: truck.plateNumber ?? '',
      brand: truck.brand ?? '',
      pricePerKm: (truck.pricePerKm ?? 0).toDouble(),
      loadCapacity: (truck.loadCapacity ?? 0).toDouble(),
      features: truck.features ?? [],
      location: truck.location ?? '',
      radiusKm: (truck.radiusKm ?? 0).toDouble(),
      images: truck.image ?? [],
      isAvailable: truck.isAvailable ?? false,
      isVerified: null,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateShipmentRequestScreen(truck: listingTruck),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(SizeManager.s16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _bookRequest,
                  icon: const Icon(Icons.assignment_outlined),
                  label: const Text('Book request'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: SizeManager.s16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeManager.r12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _connectOwner,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : const Icon(Icons.message_outlined),
                  label: const Text('Connect Owner'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.85),
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: SizeManager.s16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeManager.r12),
                    ),
                    elevation: 0,
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
