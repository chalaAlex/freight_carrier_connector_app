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
import 'package:clean_architecture/feature/freight_oner_module/signup/presentation/bloc/login/login_bloc.dart';

String? _userIdFromJwt(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    // JWT payload is base64url-encoded — pad to a multiple of 4
    final payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
    final padded = payload.padRight((payload.length + 3) ~/ 4 * 4, '=');
    final decoded = jsonDecode(utf8.decode(base64Decode(padded)));
    return decoded['id']?.toString();
  } catch (_) {
    return null;
  }
}
class ChatRoomScreen extends StatelessWidget {
  final String roomId;
  final String otherParticipantName;
  final String? currentUserId;

  const ChatRoomScreen({
    super.key,
    required this.roomId,
    required this.otherParticipantName,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final loginId = context.read<LoginBloc>().state.user?.data?.id;
    return BlocProvider(
      create: (_) => sl<ChatRoomBloc>(),
      child: _ChatRoomBody(
        roomId: roomId,
        otherParticipantName: otherParticipantName,
        currentUserId: currentUserId ?? loginId,
      ),
    );
  }
}

class _ChatRoomBody extends StatefulWidget {
  final String roomId;
  final String otherParticipantName;
  final String? currentUserId;

  const _ChatRoomBody({
    required this.roomId,
    required this.otherParticipantName,
    this.currentUserId,
  });

  @override
  State<_ChatRoomBody> createState() => _ChatRoomBodyState();
}

class _ChatRoomBodyState extends State<_ChatRoomBody> {
  final _scrollController = ScrollController();
  bool _initialScrollDone = false;
  String? _resolvedUserId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _resolveUserIdAndJoin();
  }

  Future<void> _resolveUserIdAndJoin() async {
    String? uid = widget.currentUserId;
    if (uid == null || uid.isEmpty) {
      // Fall back to decoding the stored JWT — always reliable
      final token = await sl<TokenLocalDataSource>().getToken();
      if (token != null) uid = _userIdFromJwt(token);
    }
    if (mounted) {
      setState(() => _resolvedUserId = uid);
      context.read<ChatRoomBloc>().add(
        JoinRoom(widget.roomId, currentUserId: uid),
      );
    }
  }

  String? get _currentUserId => _resolvedUserId ?? widget.currentUserId;

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
                // Scroll to bottom only on the initial page-1 load and when
                // a new message arrives (not on pagination loads).
                if (state is ChatRoomLoaded) {
                  final isInitialLoad = !_initialScrollDone;
                  final isNewMessage =
                      _initialScrollDone &&
                      state.messages.isNotEmpty &&
                      !state.messages.last.id.startsWith('pending_');
                  if (isInitialLoad || isNewMessage) {
                    _initialScrollDone = true;
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
                }
              },
              builder: (context, state) {
                if (state is ChatRoomLoading || state is ChatRoomInitial) {
                  return const Center(child: CircularProgressIndicator());
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
                        _currentUserId!.isNotEmpty &&
                        msg.senderId.isNotEmpty &&
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
