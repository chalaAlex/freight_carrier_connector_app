import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/chat/data/datasources/chat_remote_data_source.dart';
import 'package:clean_architecture/feature/chat/domain/entities/chat_room_entity.dart';
import 'package:clean_architecture/feature/chat/domain/entities/message_entity.dart';
import 'package:clean_architecture/feature/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  const ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ChatRoomEntity>> getOrCreateRoom(
    String otherUserId,
  ) async {
    try {
      final room = await remoteDataSource.getOrCreateRoom(otherUserId);
      return Right(room);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<ChatRoomEntity>>> getInbox() async {
    try {
      final rooms = await remoteDataSource.getInbox();
      return Right(rooms);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(
    String roomId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final messages = await remoteDataSource.getMessages(
        roomId,
        page: page,
        limit: limit,
      );
      return Right(messages);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String roomId) async {
    try {
      await remoteDataSource.markAsRead(roomId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
