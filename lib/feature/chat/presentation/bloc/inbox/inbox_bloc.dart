import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/feature/chat/data/datasources/chat_socket_service.dart';
import 'package:clean_architecture/feature/chat/domain/entities/chat_room_entity.dart';
import 'package:clean_architecture/feature/chat/domain/usecases/get_inbox_usecase.dart';
import 'inbox_event.dart';
import 'inbox_state.dart';

class InboxBloc extends Bloc<InboxEvent, InboxState> {
  final GetInboxUseCase getInboxUseCase;
  final ChatSocketService socketService;
  StreamSubscription? _inboxSub;

  InboxBloc({required this.getInboxUseCase, required this.socketService})
    : super(InboxInitial()) {
    on<LoadInbox>(_onLoadInbox);
    on<InboxUpdated>(_onInboxUpdated);

    _inboxSub = socketService.onInboxUpdate.listen((event) {
      add(InboxUpdated(event));
    });
  }

  Future<void> _onLoadInbox(LoadInbox event, Emitter<InboxState> emit) async {
    emit(InboxLoading());
    final result = await getInboxUseCase();
    result.fold(
      (failure) => emit(InboxError(failure.message)),
      (rooms) => emit(InboxLoaded(rooms)),
    );
  }

  void _onInboxUpdated(InboxUpdated event, Emitter<InboxState> emit) {
    final current = state;
    if (current is! InboxLoaded) return;

    final update = event.update;
    final updatedRooms = current.rooms.map((room) {
      if (room.id != update.roomId) return room;
      final preview = update.lastMessage?.text?.isNotEmpty == true
          ? update.lastMessage!.text
          : update.lastMessage?.attachmentUrl != null
          ? '📷 Image'
          : room.lastMessagePreview;
      return ChatRoomEntity(
        id: room.id,
        otherParticipantId: room.otherParticipantId,
        otherParticipantName: room.otherParticipantName,
        otherParticipantPhoto: room.otherParticipantPhoto,
        lastMessagePreview: preview,
        lastMessageAt: update.lastMessageAt ?? room.lastMessageAt,
        unreadCount: room.unreadCount + 1,
      );
    }).toList();

    // Re-sort descending by lastMessageAt
    updatedRooms.sort((a, b) {
      if (a.lastMessageAt == null) return 1;
      if (b.lastMessageAt == null) return -1;
      return b.lastMessageAt!.compareTo(a.lastMessageAt!);
    });

    emit(InboxLoaded(updatedRooms));
  }

  @override
  Future<void> close() {
    _inboxSub?.cancel();
    return super.close();
  }
}
