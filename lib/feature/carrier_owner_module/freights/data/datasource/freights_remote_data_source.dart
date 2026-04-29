import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/entity/freight_filter.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/data/model/freights_response_model.dart';

abstract class FreightsRemoteDataSource {
  Future<FreightsResponseModel> getFreights({
    int? page,
    int? limit,
    FreightFilter? filter,
  });
}
