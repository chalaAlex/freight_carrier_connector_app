import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/chat/domain/entities/chat_room_entity.dart';
import 'package:clean_architecture/feature/chat/domain/repositories/chat_repository.dart';

class GetOrCreateRoomUseCase {
  final ChatRepository repository;
  const GetOrCreateRoomUseCase(this.repository);

  Future<Either<Failure, ChatRoomEntity>> call(String otherUserId) {
    return repository.getOrCreateRoom(otherUserId);
  }
}
