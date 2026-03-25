import 'package:clean_architecture/feature/shipment_request/domain/entity/shipment_request_entity.dart';
import 'package:clean_architecture/feature/shipment_request/domain/usecases/get_sent_requests_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ── Events ────────────────────────────────────────────────────────────────

abstract class SentRequestsEvent extends Equatable {
  const SentRequestsEvent();
  @override
  List<Object?> get props => [];
}

class LoadSentRequests extends SentRequestsEvent {
  final String status;
  const LoadSentRequests(this.status);
  @override
  List<Object?> get props => [status];
}

// ── States ────────────────────────────────────────────────────────────────

abstract class SentRequestsState extends Equatable {
  const SentRequestsState();
  @override
  List<Object?> get props => [];
}

class SentRequestsInitial extends SentRequestsState {
  const SentRequestsInitial();
}

class SentRequestsLoading extends SentRequestsState {
  const SentRequestsLoading();
}

class SentRequestsLoaded extends SentRequestsState {
  final List<SentRequestEntity> requests;
  final String status;
  const SentRequestsLoaded({required this.requests, required this.status});
  @override
  List<Object?> get props => [requests, status];
}

class SentRequestsError extends SentRequestsState {
  final String message;
  const SentRequestsError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── Bloc ──────────────────────────────────────────────────────────────────

class SentRequestsBloc extends Bloc<SentRequestsEvent, SentRequestsState> {
  final GetSentRequestsUseCase getSentRequestsUseCase;

  SentRequestsBloc({required this.getSentRequestsUseCase})
    : super(const SentRequestsInitial()) {
    on<LoadSentRequests>(_onLoad);
  }

  Future<void> _onLoad(
    LoadSentRequests event,
    Emitter<SentRequestsState> emit,
  ) async {
    emit(const SentRequestsLoading());
    final result = await getSentRequestsUseCase(event.status);
    result.fold(
      (failure) => emit(SentRequestsError(failure.message)),
      (requests) =>
          emit(SentRequestsLoaded(requests: requests, status: event.status)),
    );
  }
}
