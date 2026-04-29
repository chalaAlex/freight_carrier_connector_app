import 'package:equatable/equatable.dart';
import 'package:clean_architecture/feature/chat/domain/entities/chat_room_entity.dart';

abstract class InboxState extends Equatable {
  const InboxState();
  @override
  List<Object?> get props => [];
}

class InboxInitial extends InboxState {}

class InboxLoading extends InboxState {}

class InboxLoaded extends InboxState {
  final List<ChatRoomEntity> rooms;
  const InboxLoaded(this.rooms);
  @override
  List<Object?> get props => [rooms];
}

class InboxError extends InboxState {
  final String message;
  const InboxError(this.message);
  @override
  List<Object?> get props => [message];
}
