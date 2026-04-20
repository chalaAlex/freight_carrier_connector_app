import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/cofig/env/env_config.dart';
import 'package:clean_architecture/core/storage/supabase_storage_service.dart';
import 'package:clean_architecture/core/token/toke_local_data_source.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/feature/chat/data/datasources/chat_socket_service.dart';
import 'package:clean_architecture/feature/chat/domain/entities/message_entity.dart';
import 'package:clean_architecture/feature/chat/domain/usecases/get_messages_usecase.dart';
import 'package:clean_architecture/feature/chat/domain/usecases/mark_as_read_usecase.dart';
import 'chat_room_event.dart';
import 'chat_room_state.dart';

const _allowedMimeTypes = [
  'image/jpeg',
  'image/png',
  'image/gif',
  'image/webp',
];

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final GetMessagesUseCase getMessagesUseCase;
  final MarkAsReadUseCase markAsReadUseCase;
  final ChatSocketService socketService;
  final SupabaseStorageService storageService;

  StreamSubscription? _messageSub;
  StreamSubscription? _readSub;
  String? _currentRoomId;
  String? _currentUserId;

  ChatRoomBloc({
    required this.getMessagesUseCase,
    required this.markAsReadUseCase,
    required this.socketService,
    required this.storageService,
  }) : super(ChatRoomInitial()) {
    on<JoinRoom>(_onJoinRoom);
    on<LeaveRoom>(_onLeaveRoom);
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<SendImage>(_onSendImage);
    on<MessageReceived>(_onMessageReceived);
    on<MessagesMarkedRead>(_onMessagesMarkedRead);

    _messageSub = socketService.onNewMessage.listen((msg) {
      if (msg.chatRoomId == _currentRoomId) {
        add(MessageReceived(msg));
      }
    });

    _readSub = socketService.onMessageRead.listen((event) {
      if (event.roomId == _currentRoomId) {
        add(MessagesMarkedRead(event.roomId));
      }
    });
  }

  Future<void> _onJoinRoom(JoinRoom event, Emitter<ChatRoomState> emit) async {
    _currentRoomId = event.roomId;
    _currentUserId = event.currentUserId;

    // Ensure socket is connected with the user's JWT before emitting any events
    await _ensureSocketConnected();

    socketService.joinRoom(event.roomId);
    socketService.markRead(event.roomId);
    add(LoadMessages(event.roomId));
  }

  Future<void> _ensureSocketConnected() async {
    if (socketService.isConnected) return;
    try {
      final token = await sl<TokenLocalDataSource>().getToken();
      if (token == null) return;
      // Base URL without the /api/v1 path suffix
      final rawBase = EnvConfig.config.baseUrl;
      final socketUrl = rawBase.replaceAll(RegExp(r'/api/v1.*'), '');
      socketService.connect(socketUrl, token);
    } catch (_) {}
  }

  void _onLeaveRoom(LeaveRoom event, Emitter<ChatRoomState> emit) {
    socketService.leaveRoom(event.roomId);
    _currentRoomId = null;
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<ChatRoomState> emit,
  ) async {
    if (event.page == 1) emit(ChatRoomLoading());

    final result = await getMessagesUseCase(
      GetMessagesParams(roomId: event.roomId, page: event.page),
    );

    result.fold((failure) => emit(ChatRoomError(failure.message)), (
      newMessages,
    ) {
      final current = state is ChatRoomLoaded
          ? (state as ChatRoomLoaded).messages
          : <MessageEntity>[];
      final combined = event.page == 1
          ? newMessages
          : [...newMessages, ...current];
      emit(
        ChatRoomLoaded(messages: combined, hasMore: newMessages.length == 20),
      );
    });
  }

  void _onSendMessage(SendMessage event, Emitter<ChatRoomState> emit) {
    if (event.text.trim().isEmpty) return;
    socketService.sendMessage(event.roomId, text: event.text.trim());

    // Optimistically add the message to state so it shows immediately
    final current = state;
    if (current is ChatRoomLoaded) {
      final optimistic = MessageEntity(
        id: 'pending_${DateTime.now().millisecondsSinceEpoch}',
        chatRoomId: event.roomId,
        senderId: _currentUserId ?? '',
        text: event.text.trim(),
        isRead: false,
        createdAt: DateTime.now(),
      );
      emit(current.copyWith(messages: [...current.messages, optimistic]));
    }
  }

  Future<void> _onSendImage(
    SendImage event,
    Emitter<ChatRoomState> emit,
  ) async {
    if (!_allowedMimeTypes.contains(event.mimeType)) {
      final current = state is ChatRoomLoaded
          ? (state as ChatRoomLoaded).messages
          : <MessageEntity>[];
      emit(
        MessageSendFailed(
          message: 'Invalid image type. Only JPEG, PNG, GIF, WebP allowed.',
          messages: current,
        ),
      );
      return;
    }

    try {
      final url = await storageService.upload(
        path: 'chat-attachments/${DateTime.now().millisecondsSinceEpoch}',
        file: event.imageFile,
      );
      socketService.sendMessage(
        event.roomId,
        attachmentUrl: url,
        attachmentType: event.mimeType,
      );
    } catch (e) {
      final current = state is ChatRoomLoaded
          ? (state as ChatRoomLoaded).messages
          : <MessageEntity>[];
      emit(
        MessageSendFailed(
          message: 'Failed to upload image. Please try again.',
          messages: current,
        ),
      );
    }
  }

  void _onMessageReceived(MessageReceived event, Emitter<ChatRoomState> emit) {
    final current = state;
    if (current is! ChatRoomLoaded) return;

    // Replace any pending optimistic message with the real one from the server,
    // or append if no optimistic match exists (e.g. message from the other user)
    final messages = current.messages;
    final pendingIndex = messages.indexWhere(
      (m) =>
          m.id.startsWith('pending_') &&
          m.senderId == event.message.senderId &&
          m.text == event.message.text,
    );

    final updated = pendingIndex >= 0
        ? [
            ...messages.sublist(0, pendingIndex),
            event.message,
            ...messages.sublist(pendingIndex + 1),
          ]
        : [...messages, event.message];

    emit(current.copyWith(messages: updated));
    if (_currentRoomId != null) socketService.markRead(_currentRoomId!);
  }

  void _onMessagesMarkedRead(
    MessagesMarkedRead event,
    Emitter<ChatRoomState> emit,
  ) {
    final current = state;
    if (current is! ChatRoomLoaded) return;
    final updated = current.messages
        .map((m) => m.copyWith(isRead: true))
        .toList();
    emit(current.copyWith(messages: updated));
  }

  @override
  Future<void> close() {
    _messageSub?.cancel();
    _readSub?.cancel();
    return super.close();
  }
}
