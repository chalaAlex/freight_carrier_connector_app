import 'package:clean_architecture/feature/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.chatRoomId,
    required super.senderId,
    super.senderName,
    super.senderPhoto,
    super.text,
    super.attachmentUrl,
    super.attachmentType,
    required super.isRead,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'];
    String senderId;
    String? senderName;
    String? senderPhoto;

    if (sender is Map<String, dynamic>) {
      senderId = sender['_id']?.toString() ?? '';
      final first = sender['firstName'] ?? '';
      final last = sender['lastName'] ?? '';
      senderName = '$first $last'.trim();
      senderPhoto = sender['profileImage']?.toString();
    } else {
      senderId = sender?.toString() ?? '';
    }

    return MessageModel(
      id: json['_id']?.toString() ?? '',
      chatRoomId: json['chatRoom']?.toString() ?? '',
      senderId: senderId,
      senderName: senderName,
      senderPhoto: senderPhoto,
      text: json['text']?.toString(),
      attachmentUrl: json['attachmentUrl']?.toString(),
      attachmentType: json['attachmentType']?.toString(),
      isRead: json['isRead'] as bool? ?? false,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'chatRoom': chatRoomId,
    'sender': senderId,
    'text': text,
    'attachmentUrl': attachmentUrl,
    'attachmentType': attachmentType,
    'isRead': isRead,
    'createdAt': createdAt.toIso8601String(),
  };
}
