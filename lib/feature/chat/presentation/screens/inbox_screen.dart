import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/feature/chat/domain/entities/chat_room_entity.dart';
import 'package:clean_architecture/feature/chat/presentation/bloc/inbox/inbox_bloc.dart';
import 'package:clean_architecture/feature/chat/presentation/bloc/inbox/inbox_event.dart';
import 'package:clean_architecture/feature/chat/presentation/bloc/inbox/inbox_state.dart';
import 'package:clean_architecture/feature/chat/presentation/screens/chat_room_screen.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: BlocBuilder<InboxBloc, InboxState>(
        builder: (context, state) {
          if (state is InboxLoading || state is InboxInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is InboxError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<InboxBloc>().add(const LoadInbox()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is InboxLoaded) {
            if (state.rooms.isEmpty) {
              return const Center(child: Text('No conversations yet.'));
            }
            return ListView.separated(
              itemCount: state.rooms.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) =>
                  _RoomTile(room: state.rooms[index]),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _RoomTile extends StatelessWidget {
  final ChatRoomEntity room;
  const _RoomTile({required this.room});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: room.otherParticipantPhoto != null
            ? NetworkImage(room.otherParticipantPhoto!)
            : null,
        child: room.otherParticipantPhoto == null
            ? Text(
                room.otherParticipantName.isNotEmpty
                    ? room.otherParticipantName[0].toUpperCase()
                    : '?',
              )
            : null,
      ),
      title: Text(
        room.otherParticipantName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        room.lastMessagePreview ?? 'No messages yet',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (room.lastMessageAt != null)
            Text(
              _formatDate(room.lastMessageAt!),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          if (room.unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${room.unreadCount}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatRoomScreen(
            roomId: room.id,
            otherParticipantName: room.otherParticipantName,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return '${dt.day}/${dt.month}';
  }
}
