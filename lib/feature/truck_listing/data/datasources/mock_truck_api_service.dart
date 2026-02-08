import 'dart:math';
import '../models/truck_model.dart';
import '../../domain/entities/truck.dart';

/// Exception thrown when network operations fail
class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Mock API service that simulates a remote truck data source
/// with realistic network behavior including delays and optional failures
class MockTruckApiService {
  static const int trucksPerPage = 10;
  static const int totalTrucks = 50;
  final bool simulateFailures;
  final Random _random = Random();

  MockTruckApiService({this.simulateFailures = false});

  /// Fetches a page of trucks with simulated network behavior
  /// 
  /// [page] - The page number to fetch (1-indexed)
  /// 
  /// Returns a list of [TruckModel] instances for the requested page
  /// 
  /// Throws [NetworkException] if network simulation fails (when simulateFailures is true)
  Future<List<TruckModel>> fetchTrucks(int page) async {
    // Simulate network delay between 500ms and 1500ms
    final delay = 500 + _random.nextInt(1000);
    await Future.delayed(Duration(milliseconds: delay));

    // Simulate random failures with 20% probability
    if (simulateFailures && _random.nextDouble() < 0.2) {
      throw NetworkException('Failed to fetch trucks');
    }

    // Calculate pagination
    final startIndex = (page - 1) * trucksPerPage;
    final endIndex = min(startIndex + trucksPerPage, totalTrucks);

    // Return empty list if page is out of range
    if (startIndex >= totalTrucks) {
      return [];
    }

    // Generate mock trucks for this page
    return List.generate(
      endIndex - startIndex,
      (index) => _generateMockTruck(startIndex + index),
    );
  }

  /// Generates a mock truck with diverse, realistic data
  /// 
  /// [index] - The truck index used to generate varied data
  TruckModel _generateMockTruck(int index) {
    // Diverse truck models
    final models = [
      'Isuzu FRR',
      'Hino 500',
      'Mercedes Actros',
      'Volvo FH',
      'MAN TGX',
    ];

    // Diverse transport companies
    final companies = [
      'Swift Logistics',
      'Prime Transport',
      'Eagle Freight',
      'Atlas Carriers',
    ];

    // All truck types
    final types = TruckType.values;

    // Ethiopian cities
    final locations = [
      'Addis Ababa',
      'Adama',
      'Hawassa',
      'Bahir Dar',
      'Mekelle',
    ];

    return TruckModel(
      id: 'truck_$index',
      model: models[index % models.length],
      company: companies[index % companies.length],
      pricePerDay: 5000 + (index % 10) * 500,
      pricePerHour: 250 + (index % 10) * 25,
      capacityTons: 5 + (index % 15).toDouble(),
      type: types[index % types.length],
      location: locations[index % locations.length],
      radiusKm: 30 + (index % 5) * 10.0,
      imageUrl: 'https://example.com/truck_$index.jpg',
      isAvailable: index % 3 != 0, // 2/3 available, 1/3 busy
    );
  }
}
