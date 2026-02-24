# Upload Feature Setup Guide

## Files Created

### Core
- `lib/core/storage/supabase_storage_service.dart` - Supabase storage service
- `lib/core/storage/supabase_config.dart` - Configuration file

### Data Layer
- `lib/feature/freight/data/datasources/upload_remote_data_source.dart`
- `lib/feature/freight/data/datasources/upload_remote_data_source_impl.dart`
- `lib/feature/freight/data/repositories/upload_repository_impl.dart`

### Domain Layer
- `lib/feature/freight/domain/repositories/upload_repository.dart`
- `lib/feature/freight/domain/usecases/upload_usecase.dart`

### Presentation Layer
- `lib/feature/freight/presentation/bloc/upload/upload_event.dart`
- `lib/feature/freight/presentation/bloc/upload/upload_state.dart`
- `lib/feature/freight/presentation/bloc/upload/upload_bloc.dart`

## Configuration Steps

1. **Update Supabase Config** (`lib/core/storage/supabase_config.dart`):
```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
static const String storageBucket = 'freight-images';
```

2. **Create Storage Bucket** in Supabase Dashboard:
   - Name: `freight-images`
   - Make it public for public URLs

## Usage in PostFreightPage

```dart
// 1. Listen to upload state
BlocListener<UploadBloc, UploadState>(
  listener: (context, state) {
    if (state is UploadSuccess) {
      final urls = state.uploadedUrls;
      // Use URLs in your freight creation
    } else if (state is UploadError) {
      _showErrorSnackBar(state.message);
    }
  },
)

// 2. Upload images before creating freight
if (_selectedImages.isNotEmpty) {
  context.read<UploadBloc>().add(
    UploadMultipleFilesEvent(
      files: _selectedImages,
      basePath: 'freights/${DateTime.now().millisecondsSinceEpoch}',
    ),
  );
}
```

## Dependencies Added
- `supabase_flutter: ^2.12.0`
- `image_picker: ^1.0.7`
- `permission_handler: ^11.3.0`
