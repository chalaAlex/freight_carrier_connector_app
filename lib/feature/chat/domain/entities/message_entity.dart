import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String? senderName;
  final String? senderPhoto;
  final String? text;
  final String? attachmentUrl;
  final String? attachmentType;
  final bool isRead;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    this.senderName,
    this.senderPhoto,
    this.text,
    this.attachmentUrl,
    this.attachmentType,
    required this.isRead,
    required this.createdAt,
  });

  bool get hasAttachment => attachmentUrl != null && attachmentUrl!.isNotEmpty;
  bool get isImageMessage => hasAttachment;

  MessageEntity copyWith({bool? isRead}) {
    return MessageEntity(
      id: id,
      chatRoomId: chatRoomId,
      senderId: senderId,
      senderName: senderName,
      senderPhoto: senderPhoto,
      text: text,
      attachmentUrl: attachmentUrl,
      attachmentType: attachmentType,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    chatRoomId,
    senderId,
    senderName,
    senderPhoto,
    text,
    attachmentUrl,
    attachmentType,
    isRead,
    createdAt,
  ];
}
