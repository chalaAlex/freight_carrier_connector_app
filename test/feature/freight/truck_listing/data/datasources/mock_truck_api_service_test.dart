import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture/feature/truck_listing/data/datasources/mock_truck_api_service.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck.dart';

void main() {
  late MockTruckApiService apiService;

  setUp(() {
    apiService = MockTruckApiService(simulateFailures: false);
  });

  group('MockTruckApiService', () {
    test('should return exactly 10 trucks for page 1', () async {
      // Act
      final result = await apiService.fetchTrucks(1);

      // Assert
      expect(result.length, 10);
    });

    test('should return exactly 10 trucks for page 2', () async {
      // Act
      final result = await apiService.fetchTrucks(2);

      // Assert
      expect(result.length, 10);
    });

    test('should return exactly 10 trucks for page 3', () async {
      // Act
      final result = await apiService.fetchTrucks(3);

      // Assert
      expect(result.length, 10);
    });

    test('should return exactly 10 trucks for page 4', () async {
      // Act
      final result = await apiService.fetchTrucks(4);

      // Assert
      expect(result.length, 10);
    });

    test('should return exactly 10 trucks for page 5 (last page)', () async {
      // Act
      final result = await apiService.fetchTrucks(5);

      // Assert
      expect(result.length, 10);
    });

    test('should return empty list for page 6 (beyond total)', () async {
      // Act
      final result = await apiService.fetchTrucks(6);

      // Assert
      expect(result.isEmpty, true);
    });

    test('should return empty list for page 100 (way beyond total)', () async {
      // Act
      final result = await apiService.fetchTrucks(100);

      // Assert
      expect(result.isEmpty, true);
    });

    test('should generate trucks with diverse models', () async {
      // Act
      final result = await apiService.fetchTrucks(1);

      // Assert
      expect(result.isNotEmpty, true);
      expect(result.first.model, isNotEmpty);
      expect(result.first.model, isIn(['Isuzu FRR', 'Hino 500', 'Mercedes Actros', 'Volvo FH', 'MAN TGX']));
    });

    test('should generate trucks with diverse companies', () async {
      // Act
      final result = await apiService.fetchTrucks(1);

      // Assert
      expect(result.isNotEmpty, true);
      expect(result.first.company, isNotEmpty);
      expect(result.first.company, isIn(['Swift Logistics', 'Prime Transport', 'Eagle Freight', 'Atlas Carriers']));
    });

    test('should generate trucks with all truck types', () async {
      // Act
      final result = await apiService.fetchTrucks(1);

      // Assert
      expect(result.isNotEmpty, true);
      final types = result.map((truck) => truck.type).toSet();
      expect(types.isNotEmpty, true);
    });

    test('should generate trucks with diverse locations', () async {
      // Act
      final result = await apiService.fetchTrucks(1);

      // Assert
      expect(result.isNotEmpty, true);
      expect(result.first.location, isNotEmpty);
      expect(result.first.location, isIn(['Addis Ababa', 'Adama', 'Hawassa', 'Bahir Dar', 'Mekelle']));
    });

    test('should generate trucks with valid pricing', () async {
      // Act
      final result = await apiService.fetchTrucks(1);

      // Assert
      expect(result.isNotEmpty, true);
      expect(result.first.pricePerDay, greaterThan(0));
      expect(result.first.pricePerHour, greaterThan(0));
    });

    test('should generate trucks with valid capacity', () async {
      // Act
      final result = await apiService.fetchTrucks(1);

      // Assert
      expect(result.isNotEmpty, true);
      expect(result.first.capacityTons, greaterThanOrEqualTo(5));
      expect(result.first.capacityTons, lessThanOrEqualTo(20));
    });

    test('should generate trucks with valid radius', () async {
      // Act
      final result = await apiService.fetchTrucks(1);

      // Assert
      expect(result.isNotEmpty, true);
      expect(result.first.radiusKm, greaterThanOrEqualTo(30));
      expect(result.first.radiusKm, lessThanOrEqualTo(70));
    });

    test('should generate trucks with unique IDs', () async {
      // Act
      final page1 = await apiService.fetchTrucks(1);
      final page2 = await apiService.fetchTrucks(2);

      // Assert
      final allIds = [...page1.map((t) => t.id), ...page2.map((t) => t.id)];
      final uniqueIds = allIds.toSet();
      expect(uniqueIds.length, allIds.length);
    });

    test('should simulate network delay', () async {
      // Arrange
      final stopwatch = Stopwatch()..start();

      // Act
      await apiService.fetchTrucks(1);

      // Assert
      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(500));
      expect(stopwatch.elapsedMilliseconds, lessThan(2000)); // Allow some buffer
    });

    test('should throw NetworkException when simulateFailures is true (eventually)', () async {
      // Arrange
      final failingService = MockTruckApiService(simulateFailures: true);
      bool exceptionThrown = false;

      // Act - Try multiple times since failure is probabilistic (20%)
      for (int i = 0; i < 20; i++) {
        try {
          await failingService.fetchTrucks(1);
        } on NetworkException {
          exceptionThrown = true;
          break;
        }
      }

      // Assert
      expect(exceptionThrown, true, reason: 'NetworkException should be thrown at least once in 20 attempts with 20% failure rate');
    });

    test('should return consistent data for the same page', () async {
      // Act
      final result1 = await apiService.fetchTrucks(1);
      final result2 = await apiService.fetchTrucks(1);

      // Assert
      expect(result1.length, result2.length);
      for (int i = 0; i < result1.length; i++) {
        expect(result1[i].id, result2[i].id);
        expect(result1[i].model, result2[i].model);
        expect(result1[i].company, result2[i].company);
      }
    });
  });
}
