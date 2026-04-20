import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/data/datasource/freights_remote_data_source.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/data/model/freights_response_model.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/entity/freight_filter.dart';
import 'package:clean_architecture/feature/freight_oner_module/my_loads/data/model/my_loads_base_response_model.dart';

class FreightsRemoteDataSourceImpl implements FreightsRemoteDataSource {
  final ApiClient client;

  FreightsRemoteDataSourceImpl({required this.client});

  @override
  Future<FreightsResponseModel> getFreights({
    int? page,
    int? limit,
    FreightFilter? filter,
  }) async {
    final response = await client.getFreights(
      page: page,
      limit: limit,
      cargoTypes: filter?.cargoTypes,
      truckTypes: filter?.truckTypes,
      pricingTypes: filter?.pricingTypes,
      statuses: filter?.statuses,
      pickupRegion: filter?.pickupRegion,
      pickupCity: filter?.pickupCity,
      dropoffRegion: filter?.dropoffRegion,
      dropoffCity: filter?.dropoffCity,
    );
    return _map(response);
  }

  FreightsResponseModel _map(MyLoadsBaseResponseModel r) {
    return FreightsResponseModel(
      statusCode: r.statusCode,
      message: r.message,
      total: r.total,
      freights: r.freights?.map((f) {
        return FreightItemModel(
          id: f.id,
          freightOwnerId: f.freightOwnerId,
          cargo: f.cargo == null
              ? null
              : FreightCargoModel(
                  type: f.cargo!.type,
                  description: f.cargo!.description,
                  weightKg: f.cargo!.weightKg,
                  quantity: f.cargo!.quantity,
                ),
          route: f.route == null
              ? null
              : FreightRouteModel(
                  pickup: f.route!.pickup == null
                      ? null
                      : FreightLocationModel(
                          region: f.route!.pickup!.region,
                          city: f.route!.pickup!.city,
                          address: f.route!.pickup!.address,
                        ),
                  dropoff: f.route!.dropoff == null
                      ? null
                      : FreightLocationModel(
                          region: f.route!.dropoff!.region,
                          city: f.route!.dropoff!.city,
                          address: f.route!.dropoff!.address,
                        ),
                ),
          schedule: f.schedule == null
              ? null
              : FreightScheduleModel(
                  pickupDate: f.schedule!.pickupDate,
                  deliveryDeadline: f.schedule!.deliveryDeadline,
                ),
          truckRequirement: f.truckRequirement == null
              ? null
              : FreightTruckRequirementModel(
                  type: f.truckRequirement!.type,
                  minCapacityKg: f.truckRequirement!.minCapacityKg,
                ),
          pricing: f.pricing == null
              ? null
              : FreightPricingModel(
                  type: f.pricing!.type,
                  amount: f.pricing!.amount,
                ),
          status: f.status,
          image: f.image,
          bidCount: f.bidCount,
          isAvailable: f.isAvailable,
          createdAt: f.createdAt,
          updatedAt: f.updatedAt,
        );
      }).toList(),
    );
  }
}
