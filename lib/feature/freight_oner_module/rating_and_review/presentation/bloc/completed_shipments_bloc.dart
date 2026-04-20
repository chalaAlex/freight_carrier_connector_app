import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/domain/entity/review_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/domain/usecases/get_completed_shipments_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class CompletedShipmentsEvent extends Equatable {
  const CompletedShipmentsEvent();
  @override
  List<Object?> get props => [];
}

class LoadCompletedShipments extends CompletedShipmentsEvent {
  const LoadCompletedShipments();
}

// States
abstract class CompletedShipmentsState extends Equatable {
  const CompletedShipmentsState();
  @override
  List<Object?> get props => [];
}

class CompletedShipmentsInitial extends CompletedShipmentsState {
  const CompletedShipmentsInitial();
}

class CompletedShipmentsLoading extends CompletedShipmentsState {
  const CompletedShipmentsLoading();
}

class CompletedShipmentsLoaded extends CompletedShipmentsState {
  final List<CompletedShipmentEntity> shipments;
  const CompletedShipmentsLoaded({required this.shipments});
  @override
  List<Object?> get props => [shipments];
}

class CompletedShipmentsError extends CompletedShipmentsState {
  final String message;
  const CompletedShipmentsError({required this.message});
  @override
  List<Object?> get props => [message];
}

// BLoC
class CompletedShipmentsBloc
    extends Bloc<CompletedShipmentsEvent, CompletedShipmentsState> {
  final GetCompletedShipmentsUseCase getCompletedShipmentsUseCase;

  CompletedShipmentsBloc({required this.getCompletedShipmentsUseCase})
    : super(const CompletedShipmentsInitial()) {
    on<LoadCompletedShipments>(_onLoad);
  }

  Future<void> _onLoad(
    LoadCompletedShipments event,
    Emitter<CompletedShipmentsState> emit,
  ) async {
    emit(const CompletedShipmentsLoading());
    final result = await getCompletedShipmentsUseCase(NoParams());
    result.fold(
      (failure) => emit(CompletedShipmentsError(message: failure.message)),
      (shipments) => emit(CompletedShipmentsLoaded(shipments: shipments)),
    );
  }
}
