import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/presentation/screen/bid_detail_screen.dart';
import 'package:clean_architecture/feature/notifications/domain/entities/notification_entity.dart';
import 'package:clean_architecture/feature/notifications/presentation/bloc/notification_bloc.dart';
import 'package:clean_architecture/feature/notifications/presentation/bloc/notification_event.dart';
import 'package:clean_architecture/feature/notifications/presentation/bloc/notification_state.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(const NotificationsFetchRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications'), elevation: 0),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<NotificationBloc>().add(
                      const NotificationsFetchRequested(),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is NotificationLoaded) {
            final visible = state.notifications
                .where(
                  (n) =>
                      n.type == 'BID_RECEIVED' ||
                      n.type == 'SHIPMENT_REQUEST_RECEIVED',
                )
                .toList();
            if (visible.isEmpty) {
              return const Center(child: Text('No notifications yet.'));
            }
            return ListView.builder(
              itemCount: visible.length,
              itemBuilder: (context, index) {
                final notification = visible[index];
                return _NotificationTile(
                  notification: notification,
                  onTap: () => _onTileTap(context, notification),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _onTileTap(BuildContext context, NotificationEntity notification) {
    context.read<NotificationBloc>().add(
      NotificationMarkReadRequested(notification.id),
    );

    if (notification.type == 'BID_RECEIVED') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BidDetailScreen(bidId: notification.referenceId),
        ),
      );
    } else if (notification.type == 'SHIPMENT_REQUEST_RECEIVED') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _PlaceholderDetailScreen(
            title: 'Shipment Request Detail',
            referenceId: notification.referenceId,
          ),
        ),
      );
    }
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const _NotificationTile({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    final borderColor = isUnread ? AppColors.primary : AppColors.grey;
    final dt = notification.createdAt;
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    final min = dt.minute.toString().padLeft(2, '0');
    final formattedDate =
        '${months[dt.month - 1]} ${dt.day}, ${dt.year} · $hour:$min $ampm';

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isUnread
              ? AppColors.primary.withValues(alpha: 0.04)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: borderColor, width: 4)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: TextStyle(
                fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              notification.body,
              style: const TextStyle(fontSize: 13, color: AppColors.grey),
            ),
            const SizedBox(height: 6),
            Text(
              formattedDate,
              style: const TextStyle(fontSize: 11, color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder screen used until real bid/shipment-request detail screens
/// are wired up for notification deep-linking.
class _PlaceholderDetailScreen extends StatelessWidget {
  final String title;
  final String referenceId;

  const _PlaceholderDetailScreen({
    required this.title,
    required this.referenceId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Reference ID: $referenceId',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
