import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:flutter/material.dart';

/// Shows the AI suggestion bottom sheet and returns the accepted suggestion,
/// or null if the user dismissed it.
Future<String?> showAiSuggestionSheet({
  required BuildContext context,
  required Future<String> Function() fetchSuggestion,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AiSuggestionSheet(fetchSuggestion: fetchSuggestion),
  );
}

class _AiSuggestionSheet extends StatefulWidget {
  final Future<String> Function() fetchSuggestion;
  const _AiSuggestionSheet({required this.fetchSuggestion});

  @override
  State<_AiSuggestionSheet> createState() => _AiSuggestionSheetState();
}

class _AiSuggestionSheetState extends State<_AiSuggestionSheet> {
  String? _suggestion;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final result = await widget.fetchSuggestion();
      setState(() {
        _suggestion = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.appColors;
    return Container(
      margin: const EdgeInsets.all(SizeManager.s16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(SizeManager.r16),
      ),
      padding: const EdgeInsets.all(SizeManager.s24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: cs.primary, size: 20),
              const SizedBox(width: SizeManager.s8),
              Text(
                'AI Suggestion',
                style: context.text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.textPrimary,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.close, color: cs.textSecondary),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: SizeManager.s16),
          if (_isLoading)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: SizeManager.s24),
                child: Column(
                  children: [
                    CircularProgressIndicator(color: cs.primary),
                    const SizedBox(height: SizeManager.s12),
                    Text(
                      'Generating suggestion...',
                      style: context.text.bodySmall?.copyWith(
                        color: cs.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_error != null)
            _buildError(cs)
          else
            _buildSuggestion(cs),
        ],
      ),
    );
  }

  Widget _buildSuggestion(cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(SizeManager.s16),
          decoration: BoxDecoration(
            color: context.appColors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(SizeManager.r12),
            border: Border.all(
              color: context.appColors.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            _suggestion!,
            style: context.text.bodyMedium?.copyWith(
              color: context.appColors.textPrimary,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: SizeManager.s16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _fetch,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Regenerate'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeManager.r12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: SizeManager.s12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, _suggestion),
                icon: const Icon(Icons.check, size: 16),
                label: const Text('Use this'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeManager.r12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: SizeManager.s8),
      ],
    );
  }

  Widget _buildError(cs) {
    return Column(
      children: [
        Icon(Icons.error_outline, color: cs.error, size: 40),
        const SizedBox(height: SizeManager.s8),
        Text(
          'Failed to generate suggestion',
          style: context.text.bodyMedium?.copyWith(color: cs.error),
        ),
        const SizedBox(height: SizeManager.s16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _fetch,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Try again'),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeManager.r12),
              ),
            ),
          ),
        ),
        const SizedBox(height: SizeManager.s8),
      ],
    );
  }
}
