import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:clean_architecture/feature/notifications/data/models/notification_model.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient apiClient;
  const NotificationRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await apiClient.getNotifications();
    final map = response as Map<String, dynamic>;
    final list = (map['data']['notifications'] as List<dynamic>);
    return list
        .map((n) => NotificationModel.fromJson(n as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> markAsRead(String id) async {
    await apiClient.markNotificationAsRead(id);
  }
}
