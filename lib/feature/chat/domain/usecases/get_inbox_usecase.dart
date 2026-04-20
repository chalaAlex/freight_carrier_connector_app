import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/chat/domain/entities/chat_room_entity.dart';
import 'package:clean_architecture/feature/chat/domain/repositories/chat_repository.dart';

class GetInboxUseCase {
  final ChatRepository repository;
  const GetInboxUseCase(this.repository);

  Future<Either<Failure, List<ChatRoomEntity>>> call() {
    return repository.getInbox();
  }
}
