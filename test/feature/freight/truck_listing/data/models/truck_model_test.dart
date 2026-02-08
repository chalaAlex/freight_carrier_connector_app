import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture/feature/truck_listing/data/models/truck_model.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck.dart';

void main() {
  group('TruckModel', () {
    final tTruckModel = TruckModel(
      id: 'truck_1',
      model: 'Isuzu FRR',
      company: 'Swift Logistics',
      pricePerDay: 5000.0,
      pricePerHour: 250.0,
      capacityTons: 10.0,
      type: TruckType.flatbed,
      location: 'Addis Ababa',
      radiusKm: 50.0,
      imageUrl: 'https://example.com/truck_1.jpg',
      isAvailable: true,
    );

    final tJson = {
      'id': 'truck_1',
      'model': 'Isuzu FRR',
      'company': 'Swift Logistics',
      'pricePerDay': 5000.0,
      'pricePerHour': 250.0,
      'capacityTons': 10.0,
      'type': 'flatbed',
      'location': 'Addis Ababa',
      'radiusKm': 50.0,
      'imageUrl': 'https://example.com/truck_1.jpg',
      'isAvailable': true,
    };

    test('should be a subclass of Truck entity', () {
      expect(tTruckModel, isA<Truck>());
    });

    group('fromJson', () {
      test('should return a valid TruckModel from JSON', () {
        // act
        final result = TruckModel.fromJson(tJson);

        // assert
        expect(result, equals(tTruckModel));
      });

      test('should handle integer values for numeric fields', () {
        // arrange
        final jsonWithInts = {
          'id': 'truck_1',
          'model': 'Isuzu FRR',
          'company': 'Swift Logistics',
          'pricePerDay': 5000,
          'pricePerHour': 250,
          'capacityTons': 10,
          'type': 'flatbed',
          'location': 'Addis Ababa',
          'radiusKm': 50,
          'imageUrl': 'https://example.com/truck_1.jpg',
          'isAvailable': true,
        };

        // act
        final result = TruckModel.fromJson(jsonWithInts);

        // assert
        expect(result, equals(tTruckModel));
      });

      test('should correctly deserialize all TruckType enum values', () {
        // Test flatbed
        final flatbedJson = {...tJson, 'type': 'flatbed'};
        final flatbedResult = TruckModel.fromJson(flatbedJson);
        expect(flatbedResult.type, equals(TruckType.flatbed));

        // Test refrigerated
        final refrigeratedJson = {...tJson, 'type': 'refrigerated'};
        final refrigeratedResult = TruckModel.fromJson(refrigeratedJson);
        expect(refrigeratedResult.type, equals(TruckType.refrigerated));

        // Test dryVan
        final dryVanJson = {...tJson, 'type': 'dryVan'};
        final dryVanResult = TruckModel.fromJson(dryVanJson);
        expect(dryVanResult.type, equals(TruckType.dryVan));
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // act
        final result = tTruckModel.toJson();

        // assert
        expect(result, equals(tJson));
      });

      test('should correctly serialize all TruckType enum values', () {
        // Test flatbed
        final flatbedModel = TruckModel(
          id: 'truck_1',
          model: 'Isuzu FRR',
          company: 'Swift Logistics',
          pricePerDay: 5000.0,
          pricePerHour: 250.0,
          capacityTons: 10.0,
          type: TruckType.flatbed,
          location: 'Addis Ababa',
          radiusKm: 50.0,
          imageUrl: 'https://example.com/truck_1.jpg',
          isAvailable: true,
        );
        expect(flatbedModel.toJson()['type'], equals('flatbed'));

        // Test refrigerated
        final refrigeratedModel = TruckModel(
          id: 'truck_1',
          model: 'Isuzu FRR',
          company: 'Swift Logistics',
          pricePerDay: 5000.0,
          pricePerHour: 250.0,
          capacityTons: 10.0,
          type: TruckType.refrigerated,
          location: 'Addis Ababa',
          radiusKm: 50.0,
          imageUrl: 'https://example.com/truck_1.jpg',
          isAvailable: true,
        );
        expect(refrigeratedModel.toJson()['type'], equals('refrigerated'));

        // Test dryVan
        final dryVanModel = TruckModel(
          id: 'truck_1',
          model: 'Isuzu FRR',
          company: 'Swift Logistics',
          pricePerDay: 5000.0,
          pricePerHour: 250.0,
          capacityTons: 10.0,
          type: TruckType.dryVan,
          location: 'Addis Ababa',
          radiusKm: 50.0,
          imageUrl: 'https://example.com/truck_1.jpg',
          isAvailable: true,
        );
        expect(dryVanModel.toJson()['type'], equals('dryVan'));
      });
    });

    group('JSON round-trip', () {
      test('should maintain data integrity through serialization round-trip', () {
        // act
        final json = tTruckModel.toJson();
        final result = TruckModel.fromJson(json);

        // assert
        expect(result, equals(tTruckModel));
      });
    });
  });
}
