// Freight Models
class Freight {
  final String freightOwnerId;
  final Cargo cargo;
  final RouteInfo route;
  final Schedule schedule;
  final TruckRequirement truckRequirement;
  final Pricing pricing;
  final FreightStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Freight({
    required this.freightOwnerId,
    required this.cargo,
    required this.route,
    required this.schedule,
    required this.truckRequirement,
    required this.pricing,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}

class Cargo {
  final String image;
  final String type;
  final String description;
  final int weightKg;
  final int quantity;

  Cargo({
    required this.image,
    required this.type,
    required this.description,
    required this.weightKg,
    required this.quantity,
  });
}

class RouteInfo {
  final Location pickup;
  final Location dropoff;
  final int distanceKm;

  RouteInfo({
    required this.pickup,
    required this.dropoff,
    required this.distanceKm,
  });
}

class Location {
  final String city;
  final String address;

  Location({
    required this.city,
    required this.address,
  });
}

class Schedule {
  final DateTime pickupDate;
  final DateTime deliveryDeadline;

  Schedule({
    required this.pickupDate,
    required this.deliveryDeadline,
  });
}

class TruckRequirement {
  final TruckType type;
  final int minCapacityKg;

  TruckRequirement({
    required this.type,
    required this.minCapacityKg,
  });
}

enum TruckType {
  flatbed,
  refrigerated,
  dryVan,
  tanker,
}

class Pricing {
  final PricingType type;
  final double? amount;

  Pricing({
    required this.type,
    this.amount,
  });
}

enum PricingType {
  fixed,
  bid,
}

enum FreightStatus {
  open,
  assigned,
  inTransit,
  delivered,
  cancelled,
}

// Mock Data
final freightMock = Freight(
  freightOwnerId: "65a8ee92a123bc9010fed321",
  cargo: Cargo(
    image: "example.com/sdjsfjsdfsdj.jpg",
    type: "Construction Materials",
    description: "Cement bags",
    weightKg: 12000,
    quantity: 240,
  ),
  route: RouteInfo(
    pickup: Location(
      city: "Addis Ababa",
      address: "Akaki Industrial Area",
    ),
    dropoff: Location(
      city: "Adama",
      address: "Main Warehouse Zone",
    ),
    distanceKm: 100,
  ),
  schedule: Schedule(
    pickupDate: DateTime.parse("2026-01-10T00:00:00.000Z"),
    deliveryDeadline: DateTime.parse("2026-01-11T00:00:00.000Z"),
  ),
  truckRequirement: TruckRequirement(
    type: TruckType.flatbed,
    minCapacityKg: 15000,
  ),
  pricing: Pricing(
    type: PricingType.bid,
    amount: null,
  ),
  status: FreightStatus.open,
  createdAt: DateTime.parse("2026-01-05T09:30:00.000Z"),
  updatedAt: DateTime.parse("2026-01-05T09:30:00.000Z"),
);

final List<Freight> freightMockList = [
  freightMock,
  Freight(
    freightOwnerId: "65a8ee92a123bc9010fed322",
    cargo: Cargo(
      image: "example.com/electronics.jpg",
      type: "Electronics",
      description: "Computer equipment and accessories",
      weightKg: 5000,
      quantity: 150,
    ),
    route: RouteInfo(
      pickup: Location(
        city: "Addis Ababa",
        address: "Bole District",
      ),
      dropoff: Location(
        city: "Hawassa",
        address: "Industrial Park",
      ),
      distanceKm: 275,
    ),
    schedule: Schedule(
      pickupDate: DateTime.parse("2026-01-12T00:00:00.000Z"),
      deliveryDeadline: DateTime.parse("2026-01-13T00:00:00.000Z"),
    ),
    truckRequirement: TruckRequirement(
      type: TruckType.dryVan,
      minCapacityKg: 8000,
    ),
    pricing: Pricing(
      type: PricingType.fixed,
      amount: 15000.0,
    ),
    status: FreightStatus.open,
    createdAt: DateTime.parse("2026-01-06T10:15:00.000Z"),
    updatedAt: DateTime.parse("2026-01-06T10:15:00.000Z"),
  ),
  Freight(
    freightOwnerId: "65a8ee92a123bc9010fed323",
    cargo: Cargo(
      image: "example.com/food.jpg",
      type: "Perishable Goods",
      description: "Fresh vegetables and fruits",
      weightKg: 8000,
      quantity: 320,
    ),
    route: RouteInfo(
      pickup: Location(
        city: "Bahir Dar",
        address: "Agricultural Center",
      ),
      dropoff: Location(
        city: "Addis Ababa",
        address: "Merkato Market",
      ),
      distanceKm: 565,
    ),
    schedule: Schedule(
      pickupDate: DateTime.parse("2026-01-08T00:00:00.000Z"),
      deliveryDeadline: DateTime.parse("2026-01-09T00:00:00.000Z"),
    ),
    truckRequirement: TruckRequirement(
      type: TruckType.refrigerated,
      minCapacityKg: 10000,
    ),
    pricing: Pricing(
      type: PricingType.bid,
      amount: null,
    ),
    status: FreightStatus.assigned,
    createdAt: DateTime.parse("2026-01-04T08:00:00.000Z"),
    updatedAt: DateTime.parse("2026-01-07T14:30:00.000Z"),
  ),
];
