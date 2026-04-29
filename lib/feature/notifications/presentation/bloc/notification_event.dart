import 'package:equatable/equatable.dart';
import 'package:clean_architecture/feature/notifications/domain/entities/notification_entity.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object?> get props => [];
}

class NotificationsFetchRequested extends NotificationEvent {
  const NotificationsFetchRequested();
}

class NotificationReceived extends NotificationEvent {
  final NotificationEntity notification;
  const NotificationReceived(this.notification);
  @override
  List<Object?> get props => [notification];
}

class NotificationMarkReadRequested extends NotificationEvent {
  final String notificationId;
  const NotificationMarkReadRequested(this.notificationId);
  @override
  List<Object?> get props => [notificationId];
}
