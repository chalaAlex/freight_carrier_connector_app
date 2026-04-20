import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/entity/my_bid_entity.dart';

class MyBidModel extends MyBidEntity {
  const MyBidModel({
    required super.id,
    required super.freightId,
    required super.bidAmount,
    required super.message,
    required super.status,
    super.createdAt,
    super.freightCargoDescription,
    super.freightCargoType,
    super.freightPickup,
    super.freightDropoff,
    super.freightPricingAmount,
    super.freightImage,
  });

  factory MyBidModel.fromJson(Map<String, dynamic> json) {
    final freight = json['freightId'] is Map<String, dynamic>
        ? json['freightId'] as Map<String, dynamic>
        : null;

    final cargo = freight?['cargo'] as Map<String, dynamic>?;
    final route = freight?['route'] as Map<String, dynamic>?;
    final pickup = route?['pickup'] as Map<String, dynamic>?;
    final dropoff = route?['dropoff'] as Map<String, dynamic>?;
    final pricing = freight?['pricing'] as Map<String, dynamic>?;
    final images = freight?['image'] as List<dynamic>?;

    String? pickupLabel;
    if (pickup != null) {
      pickupLabel = [
        pickup['region'],
        pickup['city'],
      ].whereType<String>().join(', ');
    }
    String? dropoffLabel;
    if (dropoff != null) {
      dropoffLabel = [
        dropoff['region'],
        dropoff['city'],
      ].whereType<String>().join(', ');
    }

    return MyBidModel(
      id: (json['_id'] ?? json['id'])?.toString() ?? '',
      freightId:
          freight?['_id']?.toString() ??
          (json['freightId'] is String ? json['freightId'] as String : ''),
      bidAmount: (json['bidAmount'] as num?)?.toDouble() ?? 0,
      message: json['message']?.toString() ?? '',
      status: json['status']?.toString() ?? 'PENDING',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      freightCargoDescription: cargo?['description']?.toString(),
      freightCargoType: cargo?['type']?.toString(),
      freightPickup: pickupLabel,
      freightDropoff: dropoffLabel,
      freightPricingAmount: (pricing?['amount'] as num?)?.toDouble(),
      freightImage: images?.isNotEmpty == true
          ? images!.first.toString()
          : null,
    );
  }
}
