import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/usecase/assign_driver_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/usecase/create_driver_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/usecase/delete_driver_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/usecase/get_driver_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/usecase/get_my_drivers_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/usecase/unassign_driver_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/usecase/update_driver_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'driver_event.dart';
import 'driver_state.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  final GetMyDriversUseCase getMyDriversUseCase;
  final GetDriverUseCase getDriverUseCase;
  final CreateDriverUseCase createDriverUseCase;
  final UpdateDriverUseCase updateDriverUseCase;
  final DeleteDriverUseCase deleteDriverUseCase;
  final AssignDriverUseCase assignDriverUseCase;
  final UnassignDriverUseCase unassignDriverUseCase;

  DriverBloc({
    required this.getMyDriversUseCase,
    required this.getDriverUseCase,
    required this.createDriverUseCase,
    required this.updateDriverUseCase,
    required this.deleteDriverUseCase,
    required this.assignDriverUseCase,
    required this.unassignDriverUseCase,
  }) : super(DriverInitial()) {
    on<LoadMyDrivers>(_onLoadMyDrivers);
    on<LoadDriver>(_onLoadDriver);
    on<CreateDriver>(_onCreateDriver);
    on<UpdateDriver>(_onUpdateDriver);
    on<DeleteDriver>(_onDeleteDriver);
    on<AssignDriver>(_onAssignDriver);
    on<UnassignDriver>(_onUnassignDriver);
  }

  Future<void> _onLoadMyDrivers(
    LoadMyDrivers event,
    Emitter<DriverState> emit,
  ) async {
    emit(DriverLoading());
    final result = await getMyDriversUseCase(NoParams());
    result.fold(
      (failure) => emit(DriverError(failure.message)),
      (drivers) => emit(DriverListLoaded(drivers)),
    );
  }

  Future<void> _onLoadDriver(
    LoadDriver event,
    Emitter<DriverState> emit,
  ) async {
    emit(DriverLoading());
    final result = await getDriverUseCase(event.id);
    result.fold(
      (failure) => emit(DriverError(failure.message)),
      (driver) => emit(DriverLoaded(driver)),
    );
  }

  Future<void> _onCreateDriver(
    CreateDriver event,
    Emitter<DriverState> emit,
  ) async {
    emit(DriverLoading());
    final result = await createDriverUseCase(event.body);
    result.fold(
      (failure) => emit(DriverError(failure.message)),
      (_) => emit(const DriverSuccess('Driver created successfully')),
    );
  }

  Future<void> _onUpdateDriver(
    UpdateDriver event,
    Emitter<DriverState> emit,
  ) async {
    emit(DriverLoading());
    final result = await updateDriverUseCase(
      UpdateDriverParams(id: event.id, body: event.body),
    );
    result.fold(
      (failure) => emit(DriverError(failure.message)),
      (_) => emit(const DriverSuccess('Driver updated successfully')),
    );
  }

  Future<void> _onDeleteDriver(
    DeleteDriver event,
    Emitter<DriverState> emit,
  ) async {
    emit(DriverLoading());
    final result = await deleteDriverUseCase(event.id);
    result.fold(
      (failure) => emit(DriverError(failure.message)),
      (_) => emit(const DriverSuccess('Driver deleted successfully')),
    );
  }

  Future<void> _onAssignDriver(
    AssignDriver event,
    Emitter<DriverState> emit,
  ) async {
    emit(DriverLoading());
    final result = await assignDriverUseCase(
      AssignDriverParams(carrierId: event.carrierId, driverId: event.driverId),
    );
    result.fold(
      (failure) => emit(DriverError(failure.message)),
      (_) => emit(const DriverSuccess('Driver assigned successfully')),
    );
  }

  Future<void> _onUnassignDriver(
    UnassignDriver event,
    Emitter<DriverState> emit,
  ) async {
    emit(DriverLoading());
    final result = await unassignDriverUseCase(
      UnassignDriverParams(
        carrierId: event.carrierId,
        driverId: event.driverId,
      ),
    );
    result.fold(
      (failure) => emit(DriverError(failure.message)),
      (_) => emit(const DriverSuccess('Driver unassigned successfully')),
    );
  }
}
