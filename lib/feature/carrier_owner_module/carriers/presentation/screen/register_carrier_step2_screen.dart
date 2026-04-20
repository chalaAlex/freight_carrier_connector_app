import 'dart:io';

import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/presentation/bloc/carrier_registration_cubit.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/presentation/bloc/carrier_registration_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

const _maxFileSizeBytes = 5 * 1024 * 1024; // 5 MB
const _maxCarrierImages = 3;

enum _SlotStatus { idle, loading, success, error }

class _SlotState {
  final _SlotStatus status;
  final File? file;
  final String? url;
  final String? errorMessage;
  final int fileSizeBytes;

  const _SlotState({
    this.status = _SlotStatus.idle,
    this.file,
    this.url,
    this.errorMessage,
    this.fileSizeBytes = 0,
  });

  _SlotState copyWith({
    _SlotStatus? status,
    File? file,
    String? url,
    String? errorMessage,
    int? fileSizeBytes,
  }) => _SlotState(
    status: status ?? this.status,
    file: file ?? this.file,
    url: url ?? this.url,
    errorMessage: errorMessage ?? this.errorMessage,
    fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
  );
}

// ─── Public screen ────────────────────────────────────────────────────────────

class RegisterCarrierStep2Screen extends StatelessWidget {
  final CarrierRegistrationFormData formData;
  const RegisterCarrierStep2Screen({super.key, required this.formData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CarrierRegistrationCubit>(),
      child: _Step2Body(formData: formData),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _Step2Body extends StatefulWidget {
  final CarrierRegistrationFormData formData;
  const _Step2Body({required this.formData});

  @override
  State<_Step2Body> createState() => _Step2BodyState();
}

class _Step2BodyState extends State<_Step2Body> {
  final _picker = ImagePicker();

  final Map<DocumentType, _SlotState> _slots = {
    DocumentType.vehicleRegistration: const _SlotState(),
    DocumentType.tradeLicense: const _SlotState(),
    DocumentType.ownerDigitalId: const _SlotState(),
  };

  // Carrier images: local file + optional uploaded URL
  final List<({File file, String? url})> _carrierImages = [];

  bool get _allUploaded =>
      _slots.values.every((s) => s.status == _SlotStatus.success);

  static String _labelFor(DocumentType type) => switch (type) {
    DocumentType.vehicleRegistration => 'Vehicle Registration Certificate',
    DocumentType.tradeLicense => 'Trade License',
    DocumentType.ownerDigitalId => 'Owner Digital ID',
  };

  Future<void> _pickAndUpload(DocumentType type) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (picked == null) return;

    final file = File(picked.path);
    final sizeBytes = await file.length();

    if (sizeBytes > _maxFileSizeBytes) {
      setState(() {
        _slots[type] = _SlotState(
          status: _SlotStatus.error,
          file: file,
          fileSizeBytes: sizeBytes,
          errorMessage: 'File is too large. Max size is 5 MB',
        );
      });
      return;
    }

    setState(() {
      _slots[type] = _SlotState(
        status: _SlotStatus.loading,
        file: file,
        fileSizeBytes: sizeBytes,
      );
    });

    if (!mounted) return;
    context.read<CarrierRegistrationCubit>().uploadDocument(type, file);
  }

  Future<void> _pickCarrierImage(ImageSource source) async {
    if (_carrierImages.length >= _maxCarrierImages) return;
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked == null || !mounted) return;

    final file = File(picked.path);
    setState(() {
      _carrierImages.add((file: file, url: null));
    });

    final url = await context
        .read<CarrierRegistrationCubit>()
        .uploadCarrierImage(file);

    if (!mounted) return;
    setState(() {
      final idx = _carrierImages.indexWhere(
        (e) => e.file.path == file.path && e.url == null,
      );
      if (idx != -1) {
        _carrierImages[idx] = (file: file, url: url);
      }
    });
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickCarrierImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(context);
                _pickCarrierImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removeCarrierImage(int index) {
    final url = _carrierImages[index].url;
    if (url != null) {
      context.read<CarrierRegistrationCubit>().removeCarrierImageUrl(url);
    }
    setState(() => _carrierImages.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarrierRegistrationCubit, CarrierRegistrationState>(
      listener: (context, state) {
        if (state is DocumentUploadSuccess) {
          setState(() {
            _slots[state.documentType] = _slots[state.documentType]!.copyWith(
              status: _SlotStatus.success,
              url: state.url,
            );
          });
        } else if (state is DocumentUploadFailure) {
          setState(() {
            _slots[state.documentType] = _slots[state.documentType]!.copyWith(
              status: _SlotStatus.error,
              errorMessage: state.message,
            );
          });
        } else if (state is CarrierRegistrationSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.carrierVerificationPending,
            (route) => route.settings.name == Routes.coHomePageRoute,
            arguments: state.carrier,
          );
        } else if (state is CarrierRegistrationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final cs = context.appColors;
        final isSubmitting = state is CarrierRegistrationLoading;

        return Scaffold(
          backgroundColor: cs.background,
          appBar: AppBar(
            backgroundColor: cs.surface,
            elevation: 0,
            title: Text(
              'Register Carrier (2/2)',
              style: context.text.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: SizeManager.screenHorizontalPadding,
              vertical: SizeManager.s24,
            ),
            children: [
              // ── Section header ──────────────────────────────────────────
              Text(
                'Upload Required Documents',
                style: context.text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: SizeManager.s4),
              Text(
                'Each file must be a JPG image under 5 MB.',
                style: context.text.bodySmall?.copyWith(color: AppColors.grey),
              ),
              const SizedBox(height: SizeManager.s24),

              // ── Upload card ─────────────────────────────────────────────
              Column(
                children: DocumentType.values.map((type) {
                  final slot = _slots[type]!;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: SizeManager.s16),
                    child: _DocumentUploadCard(
                      label: _labelFor(type),
                      slot: slot,
                      onBrowse: () => _pickAndUpload(type),
                      onRemove: () => setState(() {
                        _slots[type] = const _SlotState();
                      }),
                      onRetry: () => _pickAndUpload(type),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: SizeManager.s32),

              // ── Carrier images section ──────────────────────────────────
              Text(
                'Carrier Photos',
                style: context.text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: SizeManager.s4),
              Text(
                'Add up to 3 photos of your carrier (optional).',
                style: context.text.bodySmall?.copyWith(color: AppColors.grey),
              ),
              const SizedBox(height: SizeManager.s16),
              // Uploaded thumbnails
              if (_carrierImages.isNotEmpty) ...[
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _carrierImages.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final item = entry.value;
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            item.file,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (item.url == null)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeCarrierImage(idx),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(3),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: SizeManager.s12),
              ],
              if (_carrierImages.length < _maxCarrierImages)
                _AddPhotoCard(onTap: _showImageSourceSheet),

              const SizedBox(height: SizeManager.s32),

              // ── Submit button ─────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: (_allUploaded && !isSubmitting)
                      ? () => context
                            .read<CarrierRegistrationCubit>()
                            .submitRegistration(widget.formData)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkGrey,
                    disabledBackgroundColor: AppColors.grey.withValues(
                      alpha: 0.35,
                    ),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeManager.r12),
                    ),
                    elevation: 0,
                  ),
                  icon: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send, size: 18),
                  label: const Text(
                    'Submit Registration',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: SizeManager.s32),
            ],
          ),
        );
      },
    );
  }
}

// ─── Per-document upload card (dashed border + file row) ─────────────────────

class _DocumentUploadCard extends StatelessWidget {
  final String label;
  final _SlotState slot;
  final VoidCallback onBrowse;
  final VoidCallback onRemove;
  final VoidCallback onRetry;

  const _DocumentUploadCard({
    required this.label,
    required this.slot,
    required this.onBrowse,
    required this.onRemove,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.appColors;
    final isIdle = slot.status == _SlotStatus.idle;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(SizeManager.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              SizeManager.s16,
              SizeManager.s12,
              SizeManager.s16,
              SizeManager.s4,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: cs.textPrimary,
              ),
            ),
          ),
          if (isIdle)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SizeManager.s16,
                SizeManager.s4,
                SizeManager.s16,
                SizeManager.s16,
              ),
              child: GestureDetector(
                onTap: onBrowse,
                child: CustomPaint(
                  painter: _DashedBorderPainter(color: cs.border),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: cs.background,
                      borderRadius: BorderRadius.circular(SizeManager.r12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload_outlined,
                          size: 30,
                          color: cs.textSecondary,
                        ),
                        const SizedBox(height: SizeManager.s8),
                        Text(
                          'Drag & drop file to upload',
                          style: TextStyle(fontSize: 13, color: cs.textPrimary),
                        ),
                        const SizedBox(height: SizeManager.s4),
                        Text(
                          'or browse',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: cs.textPrimary,
                            decoration: TextDecoration.underline,
                            decorationColor: cs.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SizeManager.s16,
                SizeManager.s4,
                SizeManager.s16,
                SizeManager.s12,
              ),
              child: _FileRow(slot: slot, onRemove: onRemove, onRetry: onRetry),
            ),
        ],
      ),
    );
  }
}

// ─── Add photo card — same dashed style ───────────────────────────────────────

class _AddPhotoCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AddPhotoCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(SizeManager.r16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(SizeManager.s16),
          child: CustomPaint(
            painter: _DashedBorderPainter(color: cs.border),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: cs.background,
                borderRadius: BorderRadius.circular(SizeManager.r12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 30,
                    color: cs.textSecondary,
                  ),
                  const SizedBox(height: SizeManager.s8),
                  Text(
                    'Add a carrier photo',
                    style: TextStyle(fontSize: 13, color: cs.textPrimary),
                  ),
                  const SizedBox(height: SizeManager.s4),
                  Text(
                    'gallery or camera',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: cs.textPrimary,
                      decoration: TextDecoration.underline,
                      decorationColor: cs.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Dashed border painter ────────────────────────────────────────────────────

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  const _DashedBorderPainter({this.color = const Color(0xFFCCCCCC)});

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    const radius = 12.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(radius),
        ),
      );

    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final start = distance;
        final end = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(start, end), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Active file row ──────────────────────────────────────────────────────────

class _FileRow extends StatelessWidget {
  final _SlotState slot;
  final VoidCallback onRemove;
  final VoidCallback onRetry;

  const _FileRow({
    required this.slot,
    required this.onRemove,
    required this.onRetry,
  });

  String get _fileName =>
      slot.file != null ? slot.file!.path.split('/').last : '';

  String _formatSize(int bytes) {
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final isError = slot.status == _SlotStatus.error;
    final isLoading = slot.status == _SlotStatus.loading;
    final isSuccess = slot.status == _SlotStatus.success;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isError
                  ? Icons.broken_image_outlined
                  : Icons.insert_drive_file_outlined,
              size: 20,
              color: isError ? AppColors.error : const Color(0xFF444444),
            ),
            const SizedBox(width: SizeManager.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _fileName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isError
                          ? AppColors.error
                          : const Color(0xFF222222),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isLoading && slot.fileSizeBytes > 0) ...[
                    const SizedBox(height: SizeManager.s4),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: const LinearProgressIndicator(
                              minHeight: 2,
                              backgroundColor: Color(0xFFE0E0E0),
                              color: Color(0xFF222222),
                            ),
                          ),
                        ),
                        const SizedBox(width: SizeManager.s8),
                        Text(
                          '${_formatSize(slot.fileSizeBytes ~/ 2)}/${_formatSize(slot.fileSizeBytes)}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF888888),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: SizeManager.s8),
            if (isSuccess)
              const Icon(Icons.check_circle, size: 20, color: AppColors.success)
            else if (isError)
              const Icon(
                Icons.warning_amber_rounded,
                size: 20,
                color: AppColors.error,
              )
            else if (isLoading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF444444),
                ),
              ),
            const SizedBox(width: SizeManager.s8),
            GestureDetector(
              onTap: isError ? onRetry : onRemove,
              child: Icon(
                isError ? Icons.refresh : Icons.delete_outline,
                size: 18,
                color: const Color(0xFF888888),
              ),
            ),
          ],
        ),
        if (isError && slot.errorMessage != null) ...[
          const SizedBox(height: SizeManager.s4),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Text(
              slot.errorMessage!,
              style: const TextStyle(fontSize: 12, color: AppColors.error),
            ),
          ),
        ],
      ],
    );
  }
}
