import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';

class ImageUploadSection extends StatelessWidget {
  final AppColorScheme colorScheme;
  final List<File> selectedImages;
  final List<String> uploadedImageUrls;
  final bool isUploading;
  final int maxImages;
  final Function(ImageSource) onPickImage;
  final Function(int) onRemoveImage;

  const ImageUploadSection({
    super.key,
    required this.colorScheme,
    required this.selectedImages,
    required this.uploadedImageUrls,
    required this.isUploading,
    required this.maxImages,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image selection buttons
        if (selectedImages.length < maxImages) ...[
          Row(
            children: [
              Expanded(
                child: _ImageSourceButton(
                  colorScheme: colorScheme,
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () => onPickImage(ImageSource.camera),
                ),
              ),
              const SizedBox(width: SizeManager.s12),
              Expanded(
                child: _ImageSourceButton(
                  colorScheme: colorScheme,
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () => onPickImage(ImageSource.gallery),
                ),
              ),
            ],
          ),
          const SizedBox(height: SizeManager.s12),
          Text(
            'Maximum $maxImages images (${selectedImages.length}/$maxImages)',
            style: TextStyle(color: colorScheme.textSecondary, fontSize: 12),
          ),
        ],

        // Image grid
        if (selectedImages.isNotEmpty) ...[
          const SizedBox(height: SizeManager.s16),
          _ImageGrid(
            colorScheme: colorScheme,
            selectedImages: selectedImages,
            uploadedImageUrls: uploadedImageUrls,
            isUploading: isUploading,
            onRemoveImage: onRemoveImage,
          ),
        ],

        // Upload status
        if (uploadedImageUrls.isNotEmpty) ...[
          const SizedBox(height: SizeManager.s12),
          Container(
            padding: const EdgeInsets.all(SizeManager.s12),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(SizeManager.r6),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.cloud_done,
                  color: AppColors.success,
                  size: 20,
                ),
                const SizedBox(width: SizeManager.s8),
                Expanded(
                  child: Text(
                    '${uploadedImageUrls.length} images uploaded to cloud',
                    style: const TextStyle(
                      color: AppColors.success,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ImageSourceButton extends StatelessWidget {
  final AppColorScheme colorScheme;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImageSourceButton({
    required this.colorScheme,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: SizeManager.s16),
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: BorderRadius.circular(SizeManager.r6),
          border: Border.all(color: colorScheme.border, width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: SizeManager.s8),
            Text(
              label,
              style: TextStyle(
                color: colorScheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageGrid extends StatelessWidget {
  final AppColorScheme colorScheme;
  final List<File> selectedImages;
  final List<String> uploadedImageUrls;
  final bool isUploading;
  final Function(int) onRemoveImage;

  const _ImageGrid({
    required this.colorScheme,
    required this.selectedImages,
    required this.uploadedImageUrls,
    required this.isUploading,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: SizeManager.s8,
        mainAxisSpacing: SizeManager.s8,
      ),
      itemCount: selectedImages.length,
      itemBuilder: (context, index) {
        return _ImageItem(
          colorScheme: colorScheme,
          image: selectedImages[index],
          index: index,
          isUploaded: index < uploadedImageUrls.length,
          isUploading: isUploading && index == selectedImages.length - 1,
          onRemove: () => onRemoveImage(index),
        );
      },
    );
  }
}

class _ImageItem extends StatelessWidget {
  final AppColorScheme colorScheme;
  final File image;
  final int index;
  final bool isUploaded;
  final bool isUploading;
  final VoidCallback onRemove;

  const _ImageItem({
    required this.colorScheme,
    required this.image,
    required this.index,
    required this.isUploaded,
    required this.isUploading,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeManager.r6),
            border: Border.all(color: colorScheme.border),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(SizeManager.r6),
            child: Image.file(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),

        // Upload status indicator
        if (isUploading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeManager.r6),
                color: Colors.black.withValues(alpha: 0.5),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 3,
                ),
              ),
            ),
          ),

        // Uploaded checkmark
        if (isUploaded && !isUploading)
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: AppColors.white, size: 16),
            ),
          ),

        // Remove button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: AppColors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }
}
