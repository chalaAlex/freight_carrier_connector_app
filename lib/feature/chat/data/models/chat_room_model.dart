import 'package:clean_architecture/feature/chat/domain/entities/chat_room_entity.dart';

class ChatRoomModel extends ChatRoomEntity {
  const ChatRoomModel({
    required super.id,
    required super.otherParticipantId,
    required super.otherParticipantName,
    super.otherParticipantPhoto,
    super.lastMessagePreview,
    super.lastMessageAt,
    super.unreadCount,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    final other = json['otherParticipant'] as Map<String, dynamic>?;

    // lastMessage may be null, a Map (populated), or a String (raw ObjectId) —
    // only treat it as a message if it's actually a Map
    final lastMsgRaw = json['lastMessage'];
    final lastMsg = lastMsgRaw is Map<String, dynamic> ? lastMsgRaw : null;

    String lastPreview = '';
    if (lastMsg != null) {
      if (lastMsg['text'] != null && (lastMsg['text'] as String).isNotEmpty) {
        lastPreview = lastMsg['text'] as String;
      } else if (lastMsg['attachmentUrl'] != null) {
        lastPreview = '📷 Image';
      }
    }

    // Backend returns _id (MongoDB) — support both 'id' and '_id'
    final id = (json['_id'] ?? json['id'])?.toString() ?? '';

    return ChatRoomModel(
      id: id,
      otherParticipantId: other?['id']?.toString() ?? '',
      otherParticipantName: other?['name']?.toString() ?? 'Unknown',
      otherParticipantPhoto: other?['profileImage']?.toString(),
      lastMessagePreview: lastPreview.isEmpty ? null : lastPreview,
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.tryParse(json['lastMessageAt'].toString())
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'otherParticipantId': otherParticipantId,
    'otherParticipantName': otherParticipantName,
    'otherParticipantPhoto': otherParticipantPhoto,
    'lastMessagePreview': lastMessagePreview,
    'lastMessageAt': lastMessageAt?.toIso8601String(),
    'unreadCount': unreadCount,
  };
}
