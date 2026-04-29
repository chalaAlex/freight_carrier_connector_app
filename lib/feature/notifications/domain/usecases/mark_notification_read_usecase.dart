import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/notifications/domain/repositories/notification_repository.dart';

class MarkNotificationReadUseCase {
  final NotificationRepository repository;
  const MarkNotificationReadUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.markAsRead(id);
  }
}
