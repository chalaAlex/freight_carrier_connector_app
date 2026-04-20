import 'package:clean_architecture/feature/notifications/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.recipientId,
    required super.type,
    required super.referenceId,
    required super.title,
    required super.body,
    required super.isRead,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id']?.toString() ?? '',
      recipientId: json['recipientId']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      referenceId: json['referenceId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      isRead: json['isRead'] as bool? ?? false,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'recipientId': recipientId,
    'type': type,
    'referenceId': referenceId,
    'title': title,
    'body': body,
    'isRead': isRead,
    'createdAt': createdAt.toIso8601String(),
  };
}
