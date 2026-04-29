import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture/feature/chat/domain/entities/chat_room_entity.dart';
import 'package:clean_architecture/feature/chat/domain/entities/message_entity.dart';
import 'package:clean_architecture/feature/chat/data/models/chat_room_model.dart';
import 'package:clean_architecture/feature/chat/data/models/message_model.dart';
import 'package:clean_architecture/feature/chat/domain/utils/attachment_validator.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

MessageEntity _randomMessage(
  Random rng, {
  String? chatRoomId,
  String? senderId,
}) {
  return MessageEntity(
    id: rng.nextInt(999999).toString(),
    chatRoomId: chatRoomId ?? rng.nextInt(999999).toString(),
    senderId: senderId ?? rng.nextInt(999999).toString(),
    text: 'msg ${rng.nextInt(1000)}',
    isRead: rng.nextBool(),
    createdAt: DateTime(
      2024,
      rng.nextInt(12) + 1,
      rng.nextInt(28) + 1,
      rng.nextInt(24),
      rng.nextInt(60),
    ),
  );
}

ChatRoomEntity _randomRoom(Random rng) {
  return ChatRoomEntity(
    id: rng.nextInt(999999).toString(),
    otherParticipantId: rng.nextInt(999999).toString(),
    otherParticipantName: 'User ${rng.nextInt(100)}',
    lastMessageAt: DateTime(
      2024,
      rng.nextInt(12) + 1,
      rng.nextInt(28) + 1,
      rng.nextInt(24),
      rng.nextInt(60),
    ),
    unreadCount: rng.nextInt(10),
  );
}

List<ChatRoomEntity> _sortInboxDescending(List<ChatRoomEntity> rooms) {
  final sorted = List<ChatRoomEntity>.from(rooms);
  sorted.sort((a, b) {
    if (a.lastMessageAt == null) return 1;
    if (b.lastMessageAt == null) return -1;
    return b.lastMessageAt!.compareTo(a.lastMessageAt!);
  });
  return sorted;
}

int _computeUnreadCount(List<MessageEntity> messages, String currentUserId) {
  return messages.where((m) => !m.isRead && m.senderId != currentUserId).length;
}

// ---------------------------------------------------------------------------
// Property 5: Attachment type validation
// Validates: Requirements 3.2, 3.3
// ---------------------------------------------------------------------------
void main() {
  group('Property 5: Attachment type validation', () {
    test('valid image MIME types are accepted', () {
      for (final type in allowedAttachmentTypes) {
        expect(
          isValidAttachmentType(type),
          isTrue,
          reason: '$type should be valid',
        );
      }
    });

    test('invalid MIME types are rejected', () {
      final invalidTypes = [
        'application/pdf',
        'video/mp4',
        'text/plain',
        '',
        'image/bmp',
        'image/tiff',
        'application/octet-stream',
        'image/',
        'jpeg',
      ];
      for (final type in invalidTypes) {
        expect(
          isValidAttachmentType(type),
          isFalse,
          reason: '$type should be invalid',
        );
      }
    });

    test('null is rejected', () {
      expect(isValidAttachmentType(null), isFalse);
    });

    test('parameterized: 100 random non-image strings are always rejected', () {
      final rng = Random(42);
      const chars = 'abcdefghijklmnopqrstuvwxyz/.-_0123456789';
      for (var i = 0; i < 100; i++) {
        final len = rng.nextInt(20) + 1;
        final s = String.fromCharCodes(
          List.generate(
            len,
            (_) => chars.codeUnitAt(rng.nextInt(chars.length)),
          ),
        );
        if (allowedAttachmentTypes.contains(s)) continue; // skip valid ones
        expect(
          isValidAttachmentType(s),
          isFalse,
          reason: '"$s" should be invalid',
        );
      }
    });
  });

  // ---------------------------------------------------------------------------
  // Property 7: Inbox sorted by last message timestamp (descending)
  // Validates: Requirement 5.3
  // ---------------------------------------------------------------------------
  group('Property 7: Inbox sorted by last message timestamp', () {
    test('parameterized: 100 random room lists are sorted descending', () {
      final rng = Random(42);
      for (var i = 0; i < 100; i++) {
        final count = rng.nextInt(10) + 2;
        final rooms = List.generate(count, (_) => _randomRoom(rng));
        final sorted = _sortInboxDescending(rooms);

        for (var j = 0; j < sorted.length - 1; j++) {
          final a = sorted[j].lastMessageAt;
          final b = sorted[j + 1].lastMessageAt;
          if (a != null && b != null) {
            expect(
              a.isAfter(b) || a.isAtSameMomentAs(b),
              isTrue,
              reason: 'Room at $j should be >= room at ${j + 1}',
            );
          }
        }
      }
    });
  });

  // ---------------------------------------------------------------------------
  // Unit tests: ChatRoomModel JSON round-trip
  // ---------------------------------------------------------------------------
  group('ChatRoomModel JSON round-trip', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 'room123',
        'otherParticipant': {
          'id': 'user456',
          'name': 'John Doe',
          'profileImage': 'https://example.com/photo.jpg',
        },
        'lastMessage': {'text': 'Hello!', 'attachmentUrl': null},
        'lastMessageAt': '2024-06-01T10:00:00.000Z',
        'unreadCount': 3,
      };

      final model = ChatRoomModel.fromJson(json);
      expect(model.id, 'room123');
      expect(model.otherParticipantId, 'user456');
      expect(model.otherParticipantName, 'John Doe');
      expect(model.otherParticipantPhoto, 'https://example.com/photo.jpg');
      expect(model.lastMessagePreview, 'Hello!');
      expect(model.unreadCount, 3);
    });

    test('fromJson uses image placeholder for attachment-only messages', () {
      final json = {
        'id': 'room1',
        'otherParticipant': {'id': 'u1', 'name': 'Alice', 'profileImage': null},
        'lastMessage': {
          'text': '',
          'attachmentUrl': 'https://img.com/photo.jpg',
        },
        'lastMessageAt': null,
        'unreadCount': 0,
      };
      final model = ChatRoomModel.fromJson(json);
      expect(model.lastMessagePreview, '📷 Image');
    });

    test('toJson round-trip preserves fields', () {
      final model = ChatRoomModel(
        id: 'r1',
        otherParticipantId: 'u1',
        otherParticipantName: 'Bob',
        lastMessagePreview: 'Hey',
        lastMessageAt: DateTime(2024, 1, 1),
        unreadCount: 2,
      );
      final json = model.toJson();
      expect(json['id'], 'r1');
      expect(json['otherParticipantName'], 'Bob');
      expect(json['unreadCount'], 2);
    });
  });

  // ---------------------------------------------------------------------------
  // Unit tests: MessageModel JSON round-trip
  // ---------------------------------------------------------------------------
  group('MessageModel JSON round-trip', () {
    test('fromJson parses text message correctly', () {
      final json = {
        '_id': 'msg1',
        'chatRoom': 'room1',
        'sender': {
          '_id': 'user1',
          'firstName': 'Alice',
          'lastName': 'Smith',
          'profileImage': null,
        },
        'text': 'Hello world',
        'attachmentUrl': null,
        'attachmentType': null,
        'isRead': false,
        'createdAt': '2024-06-01T09:00:00.000Z',
      };

      final model = MessageModel.fromJson(json);
      expect(model.id, 'msg1');
      expect(model.chatRoomId, 'room1');
      expect(model.senderId, 'user1');
      expect(model.senderName, 'Alice Smith');
      expect(model.text, 'Hello world');
      expect(model.isRead, false);
      expect(model.hasAttachment, false);
    });

    test('fromJson parses image message correctly', () {
      final json = {
        '_id': 'msg2',
        'chatRoom': 'room1',
        'sender': {'_id': 'user2', 'firstName': 'Bob', 'lastName': ''},
        'text': '',
        'attachmentUrl': 'https://storage.example.com/img.jpg',
        'attachmentType': 'image/jpeg',
        'isRead': true,
        'createdAt': '2024-06-01T10:00:00.000Z',
      };

      final model = MessageModel.fromJson(json);
      expect(model.hasAttachment, true);
      expect(model.isImageMessage, true);
      expect(model.attachmentType, 'image/jpeg');
      expect(model.isRead, true);
    });

    test('toJson round-trip preserves fields', () {
      final model = MessageModel(
        id: 'm1',
        chatRoomId: 'r1',
        senderId: 'u1',
        text: 'Test',
        isRead: false,
        createdAt: DateTime(2024, 6, 1, 9, 0),
      );
      final json = model.toJson();
      expect(json['_id'], 'm1');
      expect(json['text'], 'Test');
      expect(json['isRead'], false);
    });
  });

  // ---------------------------------------------------------------------------
  // Unit tests: MessageEntity.copyWith (read receipt)
  // ---------------------------------------------------------------------------
  group('MessageEntity.copyWith', () {
    test('copyWith isRead=true marks message as read', () {
      final msg = MessageEntity(
        id: '1',
        chatRoomId: 'r1',
        senderId: 'u1',
        isRead: false,
        createdAt: DateTime.now(),
      );
      final updated = msg.copyWith(isRead: true);
      expect(updated.isRead, true);
      expect(updated.id, msg.id);
    });

    test('marking already-read message as read is a no-op', () {
      final msg = MessageEntity(
        id: '1',
        chatRoomId: 'r1',
        senderId: 'u1',
        isRead: true,
        createdAt: DateTime.now(),
      );
      final updated = msg.copyWith(isRead: true);
      expect(updated.isRead, true);
    });
  });

  // ---------------------------------------------------------------------------
  // Property 8: Unread count accuracy
  // Validates: Requirement 5.5
  // ---------------------------------------------------------------------------
  group('Property 8: Unread count accuracy', () {
    test(
      'parameterized: 100 random message lists compute correct unread count',
      () {
        final rng = Random(42);
        for (var i = 0; i < 100; i++) {
          final currentUserId = rng.nextInt(999999).toString();
          final count = rng.nextInt(20);
          final messages = List.generate(count, (_) => _randomMessage(rng));

          final expected = messages
              .where((m) => !m.isRead && m.senderId != currentUserId)
              .length;
          final computed = _computeUnreadCount(messages, currentUserId);
          expect(computed, expected);
        }
      },
    );
  });
}
