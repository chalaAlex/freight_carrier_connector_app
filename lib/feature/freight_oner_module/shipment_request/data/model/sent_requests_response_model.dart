/// Manual fromJson model for the GET /shipmentRequests/sent response.
/// The API returns: { data: { requests: [...] } }
class SentRequestsResponseModel {
  final List<SentRequestModel> requests;

  SentRequestsResponseModel({required this.requests});

  factory SentRequestsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final list = data?['requests'] as List<dynamic>? ?? [];
    return SentRequestsResponseModel(
      requests: list
          .map((e) => SentRequestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SentRequestModel {
  final String id;
  final String status;
  final bool isReviewed;
  final double? proposedPrice;
  final DateTime createdAt;
  final SentCarrierModel? carrier;
  final List<SentSnapshotModel> freightSnapshots;

  SentRequestModel({
    required this.id,
    required this.status,
    required this.isReviewed,
    this.proposedPrice,
    required this.createdAt,
    this.carrier,
    required this.freightSnapshots,
  });

  factory SentRequestModel.fromJson(Map<String, dynamic> json) {
    final carrierRaw = json['carrierId'];
    SentCarrierModel? carrier;
    if (carrierRaw is Map<String, dynamic>) {
      carrier = SentCarrierModel.fromJson(carrierRaw);
    }

    final snapshots = (json['freightSnapshots'] as List<dynamic>? ?? [])
        .map((e) => SentSnapshotModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return SentRequestModel(
      id: json['_id'] as String,
      status: json['status'] as String,
      isReviewed: json['isReviewed'] as bool? ?? false,
      proposedPrice: (json['proposedPrice'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      carrier: carrier,
      freightSnapshots: snapshots,
    );
  }
}

class SentCarrierModel {
  final String id;
  final String? brand;
  final String? model;
  final String? plateNumber;

  SentCarrierModel({
    required this.id,
    this.brand,
    this.model,
    this.plateNumber,
  });

  factory SentCarrierModel.fromJson(Map<String, dynamic> json) {
    return SentCarrierModel(
      id: json['_id'] as String? ?? '',
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      plateNumber: json['plateNumber'] as String?,
    );
  }
}

class SentSnapshotModel {
  final String? cargoType;
  final String? pickupCity;
  final String? deliveryCity;

  SentSnapshotModel({this.cargoType, this.pickupCity, this.deliveryCity});

  factory SentSnapshotModel.fromJson(Map<String, dynamic> json) {
    final pickup = json['pickupLocation'] as Map<String, dynamic>?;
    final delivery = json['deliveryLocation'] as Map<String, dynamic>?;
    return SentSnapshotModel(
      cargoType: json['cargoType'] as String?,
      pickupCity: pickup?['city'] as String?,
      deliveryCity: delivery?['city'] as String?,
    );
  }
}
