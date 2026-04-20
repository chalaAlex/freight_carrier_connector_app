import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const _allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
const _allowedMimeTypes = [
  'image/jpeg',
  'image/png',
  'image/gif',
  'image/webp',
];

class ChatInputBar extends StatefulWidget {
  final void Function(String text) onSendText;
  final void Function(File file, String mimeType) onSendImage;

  const ChatInputBar({
    super.key,
    required this.onSendText,
    required this.onSendImage,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  final _picker = ImagePicker();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSendText(text);
    _controller.clear();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;

    final ext = picked.path.split('.').last.toLowerCase();
    if (!_allowedExtensions.contains(ext)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Only JPEG, PNG, GIF, and WebP images are allowed.'),
          ),
        );
      }
      return;
    }

    final mimeType = _extToMime(ext);
    widget.onSendImage(File(picked.path), mimeType);
  }

  String _extToMime(String ext) {
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.image_outlined),
              onPressed: _pickImage,
              tooltip: 'Send image',
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 4,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Type a message…',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  isDense: true,
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _send,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
