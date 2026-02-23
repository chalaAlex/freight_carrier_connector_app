import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/core/request/create_freight_request.dart';
import 'package:clean_architecture/feature/freight/data/datasources/freight_remote_data_source.dart';
import 'package:clean_architecture/feature/freight/data/model/freight_response_model.dart';

class FreightRemoteDataSourceImpl implements FreightRemoteDataSource {
  final ApiClient client;

  FreightRemoteDataSourceImpl({required this.client});

  @override
  Future<FreightBaseResponse> createFreight(
    CreateFreightRequest request,
  ) async {
    // Convert request to DTO for serialization
    final cargoDto = CargoDto(
      type: request.cargo.type,
      description: request.cargo.description,
      weightKg: request.cargo.weightKg,
      quantity: request.cargo.quantity,
    );

    final pickupDto = LocationDto(
      region: request.route.pickup.region,
      city: request.route.pickup.city,
      address: request.route.pickup.address,
    );

    final dropoffDto = LocationDto(
      region: request.route.dropoff.region,
      city: request.route.dropoff.city,
      address: request.route.dropoff.address,
    );

    final routeDto = RouteDto(pickup: pickupDto, dropoff: dropoffDto);

    final scheduleDto = ScheduleDto(
      pickupDate: request.schedule.pickupDate.toIso8601String(),
      deliveryDeadline: request.schedule.deliveryDeadline.toIso8601String(),
    );

    final truckRequirementDto = TruckRequirementDto(
      type: request.truckRequirement.type,
      minCapacityKg: request.truckRequirement.minCapacityKg,
    );

    final pricingDto = PricingDto(
      type: request.pricing.type,
      amount: request.pricing.amount,
    );

    final freightDto = FreightDto(
      cargo: cargoDto,
      route: routeDto,
      schedule: scheduleDto,
      truckRequirement: truckRequirementDto,
      pricing: pricingDto,
    );

    // Use the generated toJson method from the DTO
    return await client.createFreight(freightDto.toJson());
  }

  @override
  Future<FreightBaseResponse> getFreights(int page) async {
    // TODO: Implement when backend supports freight listing
    throw UnimplementedError('Get freights not yet implemented');
  }
}
