import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:clean_architecture/feature/chat/domain/entities/message_entity.dart';

abstract class ChatRoomEvent extends Equatable {
  const ChatRoomEvent();
  @override
  List<Object?> get props => [];
}

class JoinRoom extends ChatRoomEvent {
  final String roomId;
  final String? currentUserId;
  const JoinRoom(this.roomId, {this.currentUserId});
  @override
  List<Object?> get props => [roomId, currentUserId];
}

class LeaveRoom extends ChatRoomEvent {
  final String roomId;
  const LeaveRoom(this.roomId);
  @override
  List<Object?> get props => [roomId];
}

class LoadMessages extends ChatRoomEvent {
  final String roomId;
  final int page;
  const LoadMessages(this.roomId, {this.page = 1});
  @override
  List<Object?> get props => [roomId, page];
}

class SendMessage extends ChatRoomEvent {
  final String roomId;
  final String text;
  const SendMessage({required this.roomId, required this.text});
  @override
  List<Object?> get props => [roomId, text];
}

class SendImage extends ChatRoomEvent {
  final String roomId;
  final File imageFile;
  final String mimeType;
  const SendImage({
    required this.roomId,
    required this.imageFile,
    required this.mimeType,
  });
  @override
  List<Object?> get props => [roomId, imageFile.path, mimeType];
}

class MessageReceived extends ChatRoomEvent {
  final MessageEntity message;
  const MessageReceived(this.message);
  @override
  List<Object?> get props => [message];
}

class MessagesMarkedRead extends ChatRoomEvent {
  final String roomId;
  const MessagesMarkedRead(this.roomId);
  @override
  List<Object?> get props => [roomId];
}
