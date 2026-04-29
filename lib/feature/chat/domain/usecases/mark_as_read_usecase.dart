import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/chat/domain/repositories/chat_repository.dart';

class MarkAsReadUseCase {
  final ChatRepository repository;
  const MarkAsReadUseCase(this.repository);

  Future<Either<Failure, void>> call(String roomId) {
    return repository.markAsRead(roomId);
  }
}
