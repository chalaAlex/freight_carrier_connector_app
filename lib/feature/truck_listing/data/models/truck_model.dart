import '../../domain/entities/truck.dart';

class TruckModel extends Truck {
  const TruckModel({
    required super.id,
    required super.model,
    required super.company,
    required super.pricePerDay,
    required super.pricePerHour,
    required super.capacityTons,
    required super.type,
    required super.location,
    required super.radiusKm,
    required super.imageUrl,
    required super.isAvailable,
  });

  factory TruckModel.fromJson(Map<String, dynamic> json) {
    return TruckModel(
      id: json['id'] as String,
      model: json['model'] as String,
      company: json['company'] as String,
      pricePerDay: (json['pricePerDay'] as num).toDouble(),
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
      capacityTons: (json['capacityTons'] as num).toDouble(),
      type: TruckType.values.byName(json['type'] as String),
      location: json['location'] as String,
      radiusKm: (json['radiusKm'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      isAvailable: json['isAvailable'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'company': company,
      'pricePerDay': pricePerDay,
      'pricePerHour': pricePerHour,
      'capacityTons': capacityTons,
      'type': type.name,
      'location': location,
      'radiusKm': radiusKm,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
    };
  }
}
