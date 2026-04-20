/// Configuration for truck data sources
/// 
/// This class provides a centralized way to configure which data source
/// to use for truck data (mock vs real API)
class TruckDataSourceConfig {
  /// Set to true to use mock data, false to use real API
  /// 
  /// When true: Uses MockTruckApiService with simulated data
  /// When false: Uses TruckApiService with real server data
  static const bool useMockData = false;
  
  /// Whether to simulate network failures in mock mode
  /// Only applies when useMockData is true
  static const bool simulateFailures = false;
  
  /// API endpoint for trucks (used in real API mode)
  static const String trucksEndpoint = '/trucks';
  
  /// Number of trucks per page
  static const int trucksPerPage = 10;
}