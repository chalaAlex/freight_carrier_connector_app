import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:clean_architecture/feature/notifications/domain/entities/notification_entity.dart';
import 'package:clean_architecture/feature/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  const NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final notifications = await remoteDataSource.getNotifications();
      return Right(notifications);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) async {
    try {
      await remoteDataSource.markAsRead(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
