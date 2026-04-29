import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/feature/notifications/domain/entities/notification_entity.dart';
import 'package:clean_architecture/feature/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:clean_architecture/feature/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:clean_architecture/feature/chat/data/datasources/chat_socket_service.dart';
import 'package:clean_architecture/feature/notifications/data/models/notification_model.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;
  final ChatSocketService chatSocketService;

  late final StreamSubscription<NotificationEntity> _notificationSubscription;

  NotificationBloc({
    required this.getNotificationsUseCase,
    required this.markNotificationReadUseCase,
    required this.chatSocketService,
  }) : super(const NotificationInitial()) {
    _notificationSubscription = chatSocketService.onNewNotification.listen(
      (notification) => add(NotificationReceived(notification)),
    );

    on<NotificationsFetchRequested>(_onFetchRequested);
    on<NotificationReceived>(_onNotificationReceived);
    on<NotificationMarkReadRequested>(_onMarkReadRequested);
  }

  Future<void> _onFetchRequested(
    NotificationsFetchRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());
    final result = await getNotificationsUseCase();
    result.fold((failure) => emit(NotificationError(failure.message)), (
      notifications,
    ) {
      final unreadCount = notifications.where((n) => !n.isRead).length;
      emit(
        NotificationLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        ),
      );
    });
  }

  void _onNotificationReceived(
    NotificationReceived event,
    Emitter<NotificationState> emit,
  ) {
    final current = state;
    if (current is NotificationLoaded) {
      final updated = [event.notification, ...current.notifications];
      emit(
        NotificationLoaded(
          notifications: updated,
          unreadCount: current.unreadCount + 1,
        ),
      );
    }
  }

  Future<void> _onMarkReadRequested(
    NotificationMarkReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final current = state;
    if (current is! NotificationLoaded) return;

    final result = await markNotificationReadUseCase(event.notificationId);
    result.fold(
      (_) {}, // on failure, do not update local state
      (_) {
        final updated = current.notifications.map((n) {
          if (n.id == event.notificationId && !n.isRead) {
            return NotificationModel(
              id: n.id,
              recipientId: n.recipientId,
              type: n.type,
              referenceId: n.referenceId,
              title: n.title,
              body: n.body,
              isRead: true,
              createdAt: n.createdAt,
            );
          }
          return n;
        }).toList();

        final unreadCount = updated.where((n) => !n.isRead).length;
        emit(
          NotificationLoaded(notifications: updated, unreadCount: unreadCount),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _notificationSubscription.cancel();
    return super.close();
  }
}
