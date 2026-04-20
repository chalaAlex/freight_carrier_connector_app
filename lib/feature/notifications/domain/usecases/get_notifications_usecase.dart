import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/notifications/domain/entities/notification_entity.dart';
import 'package:clean_architecture/feature/notifications/domain/repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;
  const GetNotificationsUseCase(this.repository);

  Future<Either<Failure, List<NotificationEntity>>> call() {
    return repository.getNotifications();
  }
}
