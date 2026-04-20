import 'package:flutter/material.dart';
import 'package:clean_architecture/feature/chat/domain/entities/message_entity.dart';

class ImageMessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isMe;

  const ImageMessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => _openFullImage(context),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200,
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              Image.network(
                message.attachmentUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : const SizedBox(
                        height: 160,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                errorBuilder: (_, __, ___) => const SizedBox(
                  height: 160,
                  child: Center(child: Icon(Icons.broken_image, size: 40)),
                ),
              ),
              Positioned(
                bottom: 6,
                right: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(message.createdAt),
                      style: const TextStyle(fontSize: 11, color: Colors.white, shadows: [Shadow(blurRadius: 2)]),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Icon(
                        message.isRead ? Icons.done_all : Icons.done,
                        size: 14,
                        color: message.isRead ? Colors.lightBlueAccent : Colors.white,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openFullImage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black, foregroundColor: Colors.white),
          body: Center(
            child: InteractiveViewer(
              child: Image.network(message.attachmentUrl!),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
