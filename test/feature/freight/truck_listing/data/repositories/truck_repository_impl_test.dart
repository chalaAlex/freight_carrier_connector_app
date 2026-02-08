import 'package:clean_architecture/feature/truck_listing/data/datasources/mock_truck_api_service.dart';
import 'package:clean_architecture/feature/truck_listing/data/models/truck_model.dart';
import 'package:clean_architecture/feature/truck_listing/data/repositories/truck_repository_impl.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

// Test double for MockTruckApiService
class FakeTruckApiService implements MockTruckApiService {
  List<TruckModel>? _trucksToReturn;
  Exception? _exceptionToThrow;
  int? _lastPageCalled;

  @override
  bool simulateFailures = false;

  void setTrucksToReturn(List<TruckModel> trucks) {
    _trucksToReturn = trucks;
    _exceptionToThrow = null;
  }

  void setExceptionToThrow(Exception exception) {
    _exceptionToThrow = exception;
    _trucksToReturn = null;
  }

  int? get lastPageCalled => _lastPageCalled;

  @override
  Future<List<TruckModel>> fetchTrucks(int page) async {
    _lastPageCalled = page;
    
    if (_exceptionToThrow != null) {
      throw _exceptionToThrow!;
    }
    
    return _trucksToReturn ?? [];
  }
}

void main() {
  late TruckRepositoryImpl repository;
  late FakeTruckApiService fakeApiService;

  setUp(() {
    fakeApiService = FakeTruckApiService();
    repository = TruckRepositoryImpl(fakeApiService);
  });

  group('TruckRepositoryImpl', () {
    group('fetchTrucks', () {
      const testPage = 1;
      final testTrucks = [
        TruckModel(
          id: 'truck_0',
          model: 'Isuzu FRR',
          company: 'Swift Logistics',
          pricePerDay: 5000,
          pricePerHour: 250,
          capacityTons: 5.0,
          type: TruckType.flatbed,
          location: 'Addis Ababa',
          radiusKm: 30.0,
          imageUrl: 'https://example.com/truck_0.jpg',
          isAvailable: true,
        ),
        TruckModel(
          id: 'truck_1',
          model: 'Hino 500',
          company: 'Prime Transport',
          pricePerDay: 5500,
          pricePerHour: 275,
          capacityTons: 6.0,
          type: TruckType.refrigerated,
          location: 'Adama',
          radiusKm: 40.0,
          imageUrl: 'https://example.com/truck_1.jpg',
          isAvailable: false,
        ),
      ];

      test('should return Right with trucks on successful fetch', () async {
        // Arrange
        fakeApiService.setTrucksToReturn(testTrucks);

        // Act
        final result = await repository.fetchTrucks(testPage);

        // Assert
        expect(result, isA<Right<dynamic, List<Truck>>>());
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (trucks) {
            expect(trucks, equals(testTrucks));
            expect(trucks.length, equals(2));
            expect(trucks[0].id, equals('truck_0'));
            expect(trucks[1].id, equals('truck_1'));
          },
        );
        expect(fakeApiService.lastPageCalled, equals(testPage));
      });

      test('should return Left with NetworkFailure on NetworkException', () async {
        // Arrange
        const errorMessage = 'Failed to fetch trucks';
        fakeApiService.setExceptionToThrow(NetworkException(errorMessage));

        // Act
        final result = await repository.fetchTrucks(testPage);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<NetworkFailure>());
            expect(failure.message, equals(errorMessage));
          },
          (trucks) => fail('Expected Left but got Right'),
        );
        expect(fakeApiService.lastPageCalled, equals(testPage));
      });

      test('should return Left with UnexpectedFailure on other exceptions', () async {
        // Arrange
        fakeApiService.setExceptionToThrow(Exception('Some unexpected error'));

        // Act
        final result = await repository.fetchTrucks(testPage);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnexpectedFailure>());
            expect(failure.message, equals('An unexpected error occurred'));
          },
          (trucks) => fail('Expected Left but got Right'),
        );
        expect(fakeApiService.lastPageCalled, equals(testPage));
      });

      test('should return Left with UnexpectedFailure on FormatException', () async {
        // Arrange
        fakeApiService.setExceptionToThrow(const FormatException('Invalid format'));

        // Act
        final result = await repository.fetchTrucks(testPage);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnexpectedFailure>());
            expect(failure.message, equals('An unexpected error occurred'));
          },
          (trucks) => fail('Expected Left but got Right'),
        );
        expect(fakeApiService.lastPageCalled, equals(testPage));
      });

      test('should return Right with empty list when API returns empty list', () async {
        // Arrange
        fakeApiService.setTrucksToReturn([]);

        // Act
        final result = await repository.fetchTrucks(testPage);

        // Assert
        expect(result, isA<Right<dynamic, List<Truck>>>());
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (trucks) {
            expect(trucks, isEmpty);
          },
        );
        expect(fakeApiService.lastPageCalled, equals(testPage));
      });

      test('should pass correct page number to API service', () async {
        // Arrange
        const differentPage = 3;
        fakeApiService.setTrucksToReturn(testTrucks);

        // Act
        await repository.fetchTrucks(differentPage);

        // Assert
        expect(fakeApiService.lastPageCalled, equals(differentPage));
      });
    });
  });
}
