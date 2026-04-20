import 'package:clean_architecture/feature/freight_oner_module/freight/domain/entity/truck_detail_entity.dart';
import 'package:equatable/equatable.dart';

abstract class TruckDetailState extends Equatable {
  const TruckDetailState();

  @override
  List<Object?> get props => [];
}

class TruckDetailInitial extends TruckDetailState {
  const TruckDetailInitial();
}

class TruckDetailLoading extends TruckDetailState {
  const TruckDetailLoading();
}

class TruckDetailLoaded extends TruckDetailState {
  final TruckDetailBaseEntity truckDetail;

  const TruckDetailLoaded(this.truckDetail);

  @override
  List<Object?> get props => [truckDetail];
}

class TruckDetailError extends TruckDetailState {
  final String message;

  const TruckDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
