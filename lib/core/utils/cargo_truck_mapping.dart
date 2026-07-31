/// Maps cargo types to suitable truck types
/// This ensures that the right truck type is automatically selected based on cargo
class CargoTruckMapping {
  // Private constructor to prevent instantiation
  CargoTruckMapping._();

  /// Map of cargo types to their suitable truck types
  static const Map<String, List<String>> _cargoToTruckMap = {
    // Liquid cargo
    'Fuel and Petroleum': ['Tanker'],
    'Chemicals': ['Tanker'],
    'Liquids': ['Tanker'],
    'Oil': ['Tanker'],
    'Water': ['Tanker'],

    // Refrigerated cargo
    'Perishable Goods': ['Refrigerated'],
    'Food': ['Refrigerated'],
    'Dairy Products': ['Refrigerated'],
    'Frozen Goods': ['Refrigerated'],
    'Meat': ['Refrigerated'],
    'Fish': ['Refrigerated'],
    'Vegetables': ['Refrigerated'],
    'Fruits': ['Refrigerated'],
    'Pharmaceuticals': ['Refrigerated'],
    'Medical Supplies': ['Refrigerated'],

    // Flatbed cargo
    'Construction Materials': ['Flatbed', 'Dump Truck'],
    'Steel': ['Flatbed'],
    'Machinery': ['Flatbed', 'Lowboy'],
    'Equipment': ['Flatbed', 'Lowboy'],
    'Lumber': ['Flatbed'],
    'Pipes': ['Flatbed'],
    'Heavy Equipment': ['Lowboy', 'Flatbed'],

    // Dump truck cargo
    'Sand': ['Dump Truck'],
    'Gravel': ['Dump Truck'],
    'Soil': ['Dump Truck'],
    'Rocks': ['Dump Truck'],
    'Aggregate': ['Dump Truck'],

    // Container cargo
    'General Cargo': ['Container', 'Box Truck'],
    'Electronics': ['Container', 'Box Truck'],
    'Furniture': ['Container', 'Box Truck'],
    'Textiles': ['Container', 'Box Truck'],
    'Clothing': ['Container', 'Box Truck'],
    'Packaged Goods': ['Container', 'Box Truck'],
    'Consumer Goods': ['Container', 'Box Truck'],

    // Livestock
    'Livestock': ['Livestock Carrier'],
    'Animals': ['Livestock Carrier'],
    'Cattle': ['Livestock Carrier'],
    'Sheep': ['Livestock Carrier'],
    'Goats': ['Livestock Carrier'],

    // Vehicles
    'Vehicles': ['Car Carrier', 'Flatbed'],
    'Cars': ['Car Carrier', 'Flatbed'],
    'Automobiles': ['Car Carrier', 'Flatbed'],

    // Bulk cargo
    'Grain': ['Bulk Carrier', 'Dump Truck'],
    'Wheat': ['Bulk Carrier', 'Dump Truck'],
    'Corn': ['Bulk Carrier', 'Dump Truck'],
    'Rice': ['Bulk Carrier', 'Dump Truck'],
    'Seeds': ['Bulk Carrier', 'Dump Truck'],
    'Cement': ['Bulk Carrier', 'Dump Truck'],
    'Powder': ['Bulk Carrier'],

    // Hazardous materials
    'Hazardous Materials': ['Tanker', 'Specialized'],
    'Explosives': ['Specialized'],
    'Radioactive': ['Specialized'],

    // Oversized cargo
    'Oversized Cargo': ['Lowboy', 'Flatbed'],
    'Large Machinery': ['Lowboy'],
    'Industrial Equipment': ['Lowboy', 'Flatbed'],
  };

  /// Get suitable truck types for a given cargo type
  /// Returns a list of truck types or an empty list if no match found
  static List<String> getTruckTypesForCargo(String cargoType) {
    if (cargoType.isEmpty) return [];

    // Try exact match first
    if (_cargoToTruckMap.containsKey(cargoType)) {
      return List<String>.from(_cargoToTruckMap[cargoType]!);
    }

    // Try case-insensitive match
    final lowerCargoType = cargoType.toLowerCase();
    for (final entry in _cargoToTruckMap.entries) {
      if (entry.key.toLowerCase() == lowerCargoType) {
        return List<String>.from(entry.value);
      }
    }

    // Try partial match (if cargo type contains any key)
    for (final entry in _cargoToTruckMap.entries) {
      if (lowerCargoType.contains(entry.key.toLowerCase()) ||
          entry.key.toLowerCase().contains(lowerCargoType)) {
        return List<String>.from(entry.value);
      }
    }

    // Default to general cargo trucks if no match
    return ['Container', 'Box Truck'];
  }

  /// Check if a cargo type has a specific mapping
  static bool hasMapping(String cargoType) {
    if (cargoType.isEmpty) return false;

    final lowerCargoType = cargoType.toLowerCase();
    return _cargoToTruckMap.keys.any(
      (key) => key.toLowerCase() == lowerCargoType,
    );
  }

  /// Get all available cargo types
  static List<String> getAllCargoTypes() {
    return _cargoToTruckMap.keys.toList()..sort();
  }

  /// Get all available truck types
  static List<String> getAllTruckTypes() {
    final allTypes = <String>{};
    for (final types in _cargoToTruckMap.values) {
      allTypes.addAll(types);
    }
    return allTypes.toList()..sort();
  }

  /// Get a description of why certain truck types are suitable for a cargo type
  static String getRecommendationReason(String cargoType) {
    final lowerCargoType = cargoType.toLowerCase();

    if (lowerCargoType.contains('fuel') ||
        lowerCargoType.contains('petroleum') ||
        lowerCargoType.contains('oil') ||
        lowerCargoType.contains('chemical') ||
        lowerCargoType.contains('liquid')) {
      return 'Tanker trucks are required for liquid cargo to prevent spillage and ensure safe transport.';
    }

    if (lowerCargoType.contains('perishable') ||
        lowerCargoType.contains('food') ||
        lowerCargoType.contains('frozen') ||
        lowerCargoType.contains('dairy') ||
        lowerCargoType.contains('meat') ||
        lowerCargoType.contains('pharmaceutical')) {
      return 'Refrigerated trucks are necessary to maintain temperature control and preserve cargo quality.';
    }

    if (lowerCargoType.contains('construction') ||
        lowerCargoType.contains('steel') ||
        lowerCargoType.contains('machinery') ||
        lowerCargoType.contains('lumber')) {
      return 'Flatbed trucks are ideal for large, heavy items that need easy loading and unloading.';
    }

    if (lowerCargoType.contains('sand') ||
        lowerCargoType.contains('gravel') ||
        lowerCargoType.contains('soil') ||
        lowerCargoType.contains('rock')) {
      return 'Dump trucks are designed for bulk materials that need to be unloaded by tilting.';
    }

    if (lowerCargoType.contains('livestock') ||
        lowerCargoType.contains('animal') ||
        lowerCargoType.contains('cattle')) {
      return 'Livestock carriers are specially designed with ventilation and safety features for animal transport.';
    }

    if (lowerCargoType.contains('vehicle') ||
        lowerCargoType.contains('car') ||
        lowerCargoType.contains('automobile')) {
      return 'Car carriers are designed to safely transport multiple vehicles at once.';
    }

    if (lowerCargoType.contains('oversized') ||
        lowerCargoType.contains('heavy equipment')) {
      return 'Lowboy trailers are designed for oversized and heavy cargo that exceeds standard dimensions.';
    }

    return 'These truck types are suitable for your cargo xbased on industry standards.';
  }
}
