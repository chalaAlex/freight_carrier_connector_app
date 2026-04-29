import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String recipientId;
  final String type; // 'BID_RECEIVED' | 'SHIPMENT_REQUEST_RECEIVED'
  final String referenceId;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.recipientId,
    required this.type,
    required this.referenceId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    recipientId,
    type,
    referenceId,
    title,
    body,
    isRead,
    createdAt,
  ];
}
