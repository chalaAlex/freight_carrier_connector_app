import 'package:equatable/equatable.dart';
import 'package:clean_architecture/feature/chat/domain/entities/message_entity.dart';

abstract class ChatRoomState extends Equatable {
  const ChatRoomState();
  @override
  List<Object?> get props => [];
}

class ChatRoomInitial extends ChatRoomState {}

class ChatRoomLoading extends ChatRoomState {}

class ChatRoomLoaded extends ChatRoomState {
  final List<MessageEntity> messages;
  final bool hasMore;
  final bool isSending;

  const ChatRoomLoaded({
    required this.messages,
    this.hasMore = true,
    this.isSending = false,
  });

  ChatRoomLoaded copyWith({
    List<MessageEntity>? messages,
    bool? hasMore,
    bool? isSending,
  }) {
    return ChatRoomLoaded(
      messages: messages ?? this.messages,
      hasMore: hasMore ?? this.hasMore,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object?> get props => [messages, hasMore, isSending];
}

class ChatRoomError extends ChatRoomState {
  final String message;
  const ChatRoomError(this.message);
  @override
  List<Object?> get props => [message];
}

class ChatDisconnected extends ChatRoomState {}

class MessageSendFailed extends ChatRoomState {
  final String message;
  final List<MessageEntity> messages;
  const MessageSendFailed({required this.message, required this.messages});
  @override
  List<Object?> get props => [message, messages];
}
