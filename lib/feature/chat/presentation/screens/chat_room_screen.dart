import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/core/token/toke_local_data_source.dart';
import 'package:clean_architecture/feature/chat/domain/entities/message_entity.dart';
import 'package:clean_architecture/feature/chat/presentation/bloc/chat_room/chat_room_bloc.dart';
import 'package:clean_architecture/feature/chat/presentation/bloc/chat_room/chat_room_event.dart';
import 'package:clean_architecture/feature/chat/presentation/bloc/chat_room/chat_room_state.dart';
import 'package:clean_architecture/feature/chat/presentation/widgets/chat_input_bar.dart';
import 'package:clean_architecture/feature/chat/presentation/widgets/image_message_bubble.dart';
import 'package:clean_architecture/feature/chat/presentation/widgets/message_bubble.dart';

/// Each navigation to ChatRoomScreen gets its own fresh ChatRoomBloc instance.
/// This ensures messages are always loaded from the API on open, and the bloc
/// is disposed when the screen is popped.
class ChatRoomScreen extends StatelessWidget {
  final String roomId;
  final String otherParticipantName;

  const ChatRoomScreen({
    super.key,
    required this.roomId,
    required this.otherParticipantName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChatRoomBloc>(),
      child: _ChatRoomBody(
        roomId: roomId,
        otherParticipantName: otherParticipantName,
      ),
    );
  }
}

class _ChatRoomBody extends StatefulWidget {
  final String roomId;
  final String otherParticipantName;

  const _ChatRoomBody({
    required this.roomId,
    required this.otherParticipantName,
  });

  @override
  State<_ChatRoomBody> createState() => _ChatRoomBodyState();
}

class _ChatRoomBodyState extends State<_ChatRoomBody> {
  final _scrollController = ScrollController();
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _initAndJoin();
  }

  Future<void> _initAndJoin() async {
    final userId = await _decodeUserIdFromToken();
    if (!mounted) return;
    setState(() => _currentUserId = userId);
    context.read<ChatRoomBloc>().add(
      JoinRoom(widget.roomId, currentUserId: userId),
    );
  }

  Future<String?> _decodeUserIdFromToken() async {
    try {
      final token = await sl<TokenLocalDataSource>().getToken();
      if (token == null) return null;
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      final map = jsonDecode(decoded) as Map<String, dynamic>;
      return map['id']?.toString();
    } catch (_) {
      return null;
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels <= 100) {
      final state = context.read<ChatRoomBloc>().state;
      if (state is ChatRoomLoaded && state.hasMore) {
        final page = (state.messages.length ~/ 20) + 1;
        context.read<ChatRoomBloc>().add(
          LoadMessages(widget.roomId, page: page),
        );
      }
    }
  }

  @override
  void dispose() {
    // LeaveRoom cleans up the socket room subscription
    context.read<ChatRoomBloc>().add(LeaveRoom(widget.roomId));
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.otherParticipantName)),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatRoomBloc, ChatRoomState>(
              listener: (context, state) {
                if (state is MessageSendFailed) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
                if (state is ChatRoomLoaded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients &&
                        _scrollController.position.maxScrollExtent > 0) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                      );
                    }
                  });
                }
              },
              builder: (context, state) {
                if (state is ChatRoomLoading || state is ChatRoomInitial) {
                  return const SizedBox.shrink();
                }
                if (state is ChatRoomError) {
                  return Center(child: Text(state.message));
                }
                if (state is ChatDisconnected) {
                  return const Center(child: Text('Reconnecting...'));
                }

                final messages = state is ChatRoomLoaded
                    ? state.messages
                    : state is MessageSendFailed
                    ? state.messages
                    : <MessageEntity>[];

                if (messages.isEmpty) {
                  return const Center(
                    child: Text('No messages yet. Say hello!'),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe =
                        _currentUserId != null &&
                        msg.senderId == _currentUserId;
                    if (msg.isImageMessage) {
                      return ImageMessageBubble(message: msg, isMe: isMe);
                    }
                    return MessageBubble(message: msg, isMe: isMe);
                  },
                );
              },
            ),
          ),
          ChatInputBar(
            onSendText: (text) => context.read<ChatRoomBloc>().add(
              SendMessage(roomId: widget.roomId, text: text),
            ),
            onSendImage: (File file, String mimeType) =>
                context.read<ChatRoomBloc>().add(
                  SendImage(
                    roomId: widget.roomId,
                    imageFile: file,
                    mimeType: mimeType,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
