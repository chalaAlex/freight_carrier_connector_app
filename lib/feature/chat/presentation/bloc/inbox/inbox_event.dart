import 'package:equatable/equatable.dart';
import 'package:clean_architecture/feature/chat/data/datasources/chat_socket_service.dart';

abstract class InboxEvent extends Equatable {
  const InboxEvent();
  @override
  List<Object?> get props => [];
}

class LoadInbox extends InboxEvent {
  const LoadInbox();
}

class InboxUpdated extends InboxEvent {
  final InboxUpdateEvent update;
  const InboxUpdated(this.update);
  @override
  List<Object?> get props => [update];
}
