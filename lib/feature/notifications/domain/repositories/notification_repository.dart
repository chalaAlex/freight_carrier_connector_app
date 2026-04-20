import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/notifications/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, void>> markAsRead(String id);
}
