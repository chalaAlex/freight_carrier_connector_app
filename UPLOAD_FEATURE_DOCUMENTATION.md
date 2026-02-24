# File Upload Feature Documentation

## Overview
This document describes the complete implementation of the file upload feature using Supabase Storage, following clean architecture principles with BLoC state management.

## Architecture Layers

### 1. Data Layer

#### Data Sources
- **`upload_remote_data_source.dart`**: Abstract interface for file upload operations
- **`upload_remote_data_source_impl.dart`**: Implementation using SupabaseStorageService

#### Models
No specific models needed as we're working directly with File objects and returning URLs.

#### Repositories
- **`upload_repository_impl.dart`**: Implements FileRepository with error handling using Either<Failure, T>

### 2. Domain Layer

#### Entities
No specific entities - working with primitive types (File, String, List<String>)

#### Repositories
- **`upload_repository.dart`**: Abstract repository interface defining upload contracts

#### Use Cases
- **`UploadFileUseCase`**: Uploads a single file
- **`UploadMultipleFilesUseCase`**: Uploads multiple files in batch
- **`UploadFileParams`**: Parameters for single file upload
- **`UploadMultipleFilesParams`**: Parameters for multiple files upload

### 3. Presentation Layer

#### BLoC
- **`upload_event.dart`**: Events for upload operations
  - `UploadSingleFileEvent`: Trigger single file upload
  - `UploadMultipleFilesEvent`: Trigger multiple files upload
  - `ResetUploadEvent`: Reset upload state

- **`upload_state.dart`**: States for upload operations
  - `UploadInitial`: Initial state
  - `UploadLoading`: Upload in progress (with progress tracking)
  - `UploadSuccess`: Upload completed successfully
  - `UploadError`: Upload failed with error message

- **`upload_bloc.dart`**: Business logic for handling upload operations

## Core Services

### SupabaseStorageService
Located at: `lib/core/storage/supabase_storage_service.dart`

**Methods:**
- `upload({required String path, required File file})`: Upload single file
- `uploadMultiple({required String basePath, required List<File> files})`: Upload multiple files
- `delete(String path)`: Delete a file from storage

**Features:**
- Automatic file naming with timestamps
- Public URL generation
- Error handling
- Cache control configuration

### SupabaseConfig
Located at: `lib/core/storage/supabase_config.dart`

**Configuration:**
```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
static const String storageBucket = 'freight-images';
```

## Dependency Injection

All upload-related dependencies are registered in `lib/core/di.dart`:

```dart
// Supabase Client
sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

// Storage Service
sl.registerLazySingleton<SupabaseStorageService>(
  () => SupabaseStorageService(sl(), SupabaseConfig.storageBucket),
);

// Data Source
sl.registerFactory<FileRemoteDataSource>(
  () => FileRemoteDataSourceImpl(sl()),
);

// Repository
sl.registerFactory<FileRepository>(() => FileRepositoryImpl(sl()));

// Use Cases
sl.registerFactory(() => UploadFileUseCase(sl()));
sl.registerFactory(() => UploadMultipleFilesUseCase(sl()));

// BLoC
sl.registerFactory(
  () => UploadBloc(
    uploadFileUseCase: sl(),
    uploadMultipleFilesUseCase: sl(),
  ),
);
```

## Usage in UI

### 1. Add UploadBloc to your widget tree
The UploadBloc is already provided globally in `main_dev.dart`:

```dart
BlocProvider(create: (_) => sl<UploadBloc>()),
```

### 2. Upload files from your UI

```dart
// Upload single file
context.read<UploadBloc>().add(
  UploadSingleFileEvent(
    file: imageFile,
    path: 'freights/user_123',
  ),
);

// Upload multiple files
context.read<UploadBloc>().add(
  UploadMultipleFilesEvent(
    files: selectedImages,
    basePath: 'freights/freight_456',
  ),
);
```

### 3. Listen to upload states

```dart
BlocListener<UploadBloc, UploadState>(
  listener: (context, state) {
    if (state is UploadLoading) {
      // Show loading indicator
      print('Uploading ${state.currentIndex}/${state.totalFiles}');
    } else if (state is UploadSuccess) {
      // Handle success
      final urls = state.uploadedUrls;
      print('Uploaded URLs: $urls');
    } else if (state is UploadError) {
      // Handle error
      print('Upload failed: ${state.message}');
    }
  },
  child: YourWidget(),
)
```

### 4. Display upload progress

```dart
BlocBuilder<UploadBloc, UploadState>(
  builder: (context, state) {
    if (state is UploadLoading) {
      return Column(
        children: [
          CircularProgressIndicator(),
          Text('Uploading ${state.currentIndex}/${state.totalFiles}'),
        ],
      );
    }
    return YourNormalWidget();
  },
)
```

## Setup Instructions

### 1. Configure Supabase

1. Create a Supabase project at https://supabase.com
2. Create a storage bucket named `freight-images` (or your preferred name)
3. Set bucket to public if you want public URLs
4. Update `lib/core/storage/supabase_config.dart` with your credentials:

```dart
static const String supabaseUrl = 'https://your-project.supabase.co';
static const String supabaseAnonKey = 'your-anon-key';
static const String storageBucket = 'freight-images';
```

### 2. Bucket Policies

Set up storage policies in Supabase dashboard:

**For public uploads:**
```sql
-- Allow authenticated users to upload
CREATE POLICY "Allow authenticated uploads"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'freight-images');

-- Allow public read access
CREATE POLICY "Allow public downloads"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'freight-images');
```

### 3. File Size Limits

The image picker is configured with:
- Max width: 1920px
- Max height: 1080px
- Image quality: 85%
- Max file size: 5MB (validated in PostFreightPage)

## Error Handling

The upload feature uses the Either monad from dartz for error handling:

```dart
Future<Either<Failure, List<String>>> uploadMultipleFiles({
  required String basePath,
  required List<File> files,
});
```

**Common errors:**
- Network errors
- Permission errors
- File size exceeded
- Invalid file format
- Supabase storage errors

All errors are caught and converted to `Failure` objects with descriptive messages.

## Testing

### Unit Tests
Test the use cases, repository, and data sources independently:

```dart
test('should upload file successfully', () async {
  // Arrange
  final file = File('test.jpg');
  final expectedUrl = 'https://storage.url/test.jpg';
  
  // Act
  final result = await uploadFileUseCase(
    UploadFileParams(path: 'test', file: file),
  );
  
  // Assert
  expect(result, Right(expectedUrl));
});
```

### Integration Tests
Test the complete flow from BLoC to Supabase.

## Best Practices

1. **Always validate file size before upload** (done in PostFreightPage)
2. **Use meaningful file paths** (e.g., `freights/{freightId}/image_{timestamp}.jpg`)
3. **Handle upload errors gracefully** with user-friendly messages
4. **Show upload progress** for better UX
5. **Reset upload state** after successful upload or navigation
6. **Compress images** before upload to save bandwidth
7. **Use unique file names** to avoid conflicts (timestamps are used)

## Future Enhancements

1. **Upload progress tracking**: Add real-time progress percentage
2. **Retry mechanism**: Automatically retry failed uploads
3. **Batch upload optimization**: Upload files in parallel
4. **Image compression**: Add image compression before upload
5. **Thumbnail