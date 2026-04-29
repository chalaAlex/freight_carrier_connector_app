import 'package:equatable/equatable.dart';

class ChatRoomEntity extends Equatable {
  final String id;
  final String otherParticipantId;
  final String otherParticipantName;
  final String? otherParticipantPhoto;
  final String? lastMessagePreview;
  final DateTime? lastMessageAt;
  final int unreadCount;

  const ChatRoomEntity({
    required this.id,
    required this.otherParticipantId,
    required this.otherParticipantName,
    this.otherParticipantPhoto,
    this.lastMessagePreview,
    this.lastMessageAt,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [
    id,
    otherParticipantId,
    otherParticipantName,
    otherParticipantPhoto,
    lastMessagePreview,
    lastMessageAt,
    unreadCount,
  ];
}
