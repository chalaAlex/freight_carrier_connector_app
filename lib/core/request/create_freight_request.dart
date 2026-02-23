class CreateFreightRequest {
  final Cargo cargo;
  final FreightRoute route;
  final Schedule schedule;
  final TruckRequirement truckRequirement;
  final Pricing pricing;

  const CreateFreightRequest({
    required this.cargo,
    required this.route,
    required this.schedule,
    required this.truckRequirement,
    required this.pricing,
  });
}

class Cargo {
  final String type;
  final String description;
  final double weightKg;
  final int quantity;

  const Cargo({
    required this.type,
    required this.description,
    required this.weightKg,
    required this.quantity,
  });
}

class FreightRoute {
  final Location pickup;
  final Location dropoff;

  const FreightRoute({required this.pickup, required this.dropoff});
}

class Location {
  final String region;
  final String city;
  final String address;

  const Location({
    required this.region,
    required this.city,
    required this.address,
  });
}

class Schedule {
  final DateTime pickupDate;
  final DateTime deliveryDeadline;

  const Schedule({required this.pickupDate, required this.deliveryDeadline});
}

class TruckRequirement {
  final String type;
  final double minCapacityKg;

  const TruckRequirement({required this.type, required this.minCapacityKg});
}

class Pricing {
  final String type;
  final double amount;

  const Pricing({required this.type, required this.amount});
}
