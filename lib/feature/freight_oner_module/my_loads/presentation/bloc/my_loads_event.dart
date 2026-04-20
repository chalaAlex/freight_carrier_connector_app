import 'package:equatable/equatable.dart';

abstract class MyLoadsEvent extends Equatable {
  const MyLoadsEvent();

  @override
  List<Object?> get props => [];
}

class FetchMyLoads extends MyLoadsEvent {
  final String status;

  const FetchMyLoads(this.status);

  @override
  List<Object?> get props => [status];
}

class RefreshMyLoads extends MyLoadsEvent {
  final String status;

  const RefreshMyLoads(this.status);

  @override
  List<Object?> get props => [status];
}
