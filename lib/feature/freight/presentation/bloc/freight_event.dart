import 'package:clean_architecture/core/request/create_freight_request.dart';
import 'package:equatable/equatable.dart';

abstract class FreightEvent extends Equatable {
  const FreightEvent();

  @override
  List<Object?> get props => [];
}

/// Event to create/post a new freight
class CreateFreightEvent extends FreightEvent {
  final CreateFreightRequest request;

  const CreateFreightEvent(this.request);

  @override
  List<Object?> get props => [request];
}

/// Event to fetch freight list
class FetchFreightsEvent extends FreightEvent {
  final int page;

  const FetchFreightsEvent(this.page);

  @override
  List<Object?> get props => [page];
}
