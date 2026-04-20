import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/chat/domain/entities/message_entity.dart';
import 'package:clean_architecture/feature/chat/domain/repositories/chat_repository.dart';

class GetMessagesParams {
  final String roomId;
  final int page;
  final int limit;
  const GetMessagesParams({
    required this.roomId,
    this.page = 1,
    this.limit = 20,
  });
}

class GetMessagesUseCase {
  final ChatRepository repository;
  const GetMessagesUseCase(this.repository);

  Future<Either<Failure, List<MessageEntity>>> call(GetMessagesParams params) {
    return repository.getMessages(
      params.roomId,
      page: params.page,
      limit: params.limit,
    );
  }
}
