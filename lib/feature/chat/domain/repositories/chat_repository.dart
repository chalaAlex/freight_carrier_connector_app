import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/chat/domain/entities/chat_room_entity.dart';
import 'package:clean_architecture/feature/chat/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, ChatRoomEntity>> getOrCreateRoom(String otherUserId);
  Future<Either<Failure, List<ChatRoomEntity>>> getInbox();
  Future<Either<Failure, List<MessageEntity>>> getMessages(
    String roomId, {
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, void>> markAsRead(String roomId);
}
