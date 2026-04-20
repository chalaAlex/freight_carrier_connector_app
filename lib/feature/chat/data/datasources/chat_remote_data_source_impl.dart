import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/chat/data/datasources/chat_remote_data_source.dart';
import 'package:clean_architecture/feature/chat/data/models/chat_room_model.dart';
import 'package:clean_architecture/feature/chat/data/models/message_model.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiClient apiClient;
  const ChatRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ChatRoomModel> getOrCreateRoom(String otherUserId) async {
    final response = await apiClient.getOrCreateRoom(otherUserId);
    final map = response as Map<String, dynamic>;
    final data = map['data']['room'] as Map<String, dynamic>;
    return ChatRoomModel.fromJson(data);
  }

  @override
  Future<List<ChatRoomModel>> getInbox() async {
    final response = await apiClient.getInbox();
    final rooms =
        (response as Map<String, dynamic>)['data']['rooms'] as List<dynamic>;
    return rooms
        .map((r) => ChatRoomModel.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<MessageModel>> getMessages(
    String roomId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await apiClient.getChatMessages(roomId, page, limit);
    final messages =
        (response as Map<String, dynamic>)['data']['messages'] as List<dynamic>;
    return messages
        .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> markAsRead(String roomId) async {
    await apiClient.markChatAsRead(roomId);
  }
}
