import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:clean_architecture/feature/chat/data/models/message_model.dart';
import 'package:clean_architecture/feature/notifications/data/models/notification_model.dart';
import 'package:clean_architecture/feature/notifications/domain/entities/notification_entity.dart';

class ReadReceiptEvent {
  final String roomId;
  final String readerId;
  const ReadReceiptEvent({required this.roomId, required this.readerId});
}

class InboxUpdateEvent {
  final String roomId;
  final MessageModel? lastMessage;
  final DateTime? lastMessageAt;
  const InboxUpdateEvent({
    required this.roomId,
    this.lastMessage,
    this.lastMessageAt,
  });
}

class ChatSocketService {
  IO.Socket? _socket;

  final _newMessageController = StreamController<MessageModel>.broadcast();
  final _messageReadController = StreamController<ReadReceiptEvent>.broadcast();
  final _inboxUpdateController = StreamController<InboxUpdateEvent>.broadcast();
  final _notificationController =
      StreamController<NotificationEntity>.broadcast();

  Stream<MessageModel> get onNewMessage => _newMessageController.stream;
  Stream<ReadReceiptEvent> get onMessageRead => _messageReadController.stream;
  Stream<InboxUpdateEvent> get onInboxUpdate => _inboxUpdateController.stream;
  Stream<NotificationEntity> get onNewNotification =>
      _notificationController.stream;

  bool get isConnected => _socket?.connected ?? false;

  void connect(String baseUrl, String token) {
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableAutoConnect()
          .enableReconnection()
          .build(),
    );

    _socket!.onConnect((_) {
      // Personal room is joined server-side on connection
    });

    _socket!.on('new_message', (data) {
      try {
        final msg = MessageModel.fromJson(data as Map<String, dynamic>);
        _newMessageController.add(msg);
      } catch (_) {}
    });

    _socket!.on('message_read', (data) {
      try {
        final map = data as Map<String, dynamic>;
        _messageReadController.add(
          ReadReceiptEvent(
            roomId: map['roomId']?.toString() ?? '',
            readerId: map['readerId']?.toString() ?? '',
          ),
        );
      } catch (_) {}
    });

    _socket!.on('inbox_update', (data) {
      try {
        final map = data as Map<String, dynamic>;
        MessageModel? lastMsg;
        if (map['lastMessage'] != null) {
          lastMsg = MessageModel.fromJson(
            map['lastMessage'] as Map<String, dynamic>,
          );
        }
        _inboxUpdateController.add(
          InboxUpdateEvent(
            roomId: map['roomId']?.toString() ?? '',
            lastMessage: lastMsg,
            lastMessageAt: map['lastMessageAt'] != null
                ? DateTime.tryParse(map['lastMessageAt'].toString())
                : null,
          ),
        );
      } catch (_) {}
    });

    _socket!.on('new_notification', (data) {
      try {
        final notification = NotificationModel.fromJson(
          data as Map<String, dynamic>,
        );
        _notificationController.add(notification);
      } catch (_) {}
    });

    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  void joinRoom(String roomId) {
    _socket?.emit('join_room', {'roomId': roomId});
  }

  void leaveRoom(String roomId) {
    _socket?.emit('leave_room', {'roomId': roomId});
  }

  void sendMessage(
    String roomId, {
    String? text,
    String? attachmentUrl,
    String? attachmentType,
  }) {
    _socket?.emit('send_message', {
      'roomId': roomId,
      if (text != null) 'text': text,
      if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
      if (attachmentType != null) 'attachmentType': attachmentType,
    });
  }

  void markRead(String roomId) {
    _socket?.emit('mark_read', {'roomId': roomId});
  }

  void dispose() {
    disconnect();
    _newMessageController.close();
    _messageReadController.close();
    _inboxUpdateController.close();
    _notificationController.close();
  }
}
