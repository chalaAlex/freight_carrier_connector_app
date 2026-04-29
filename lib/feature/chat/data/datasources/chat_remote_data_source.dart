import 'package:clean_architecture/feature/chat/data/models/chat_room_model.dart';
import 'package:clean_architecture/feature/chat/data/models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<ChatRoomModel> getOrCreateRoom(String otherUserId);
  Future<List<ChatRoomModel>> getInbox();
  Future<List<MessageModel>> getMessages(
    String roomId, {
    int page = 1,
    int limit = 20,
  });
  Future<void> markAsRead(String roomId);
}
