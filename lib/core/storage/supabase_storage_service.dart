import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  final SupabaseClient _client;
  final String _bucketName;

  SupabaseStorageService(this._client, this._bucketName);

  /// Upload a file to Supabase storage
  /// Returns the public URL of the uploaded file
  Future<String> upload({required String path, required File file}) async {
    try {
      // Upload file to Supabase storage
      final String fileName = path.split('/').last;
      final String filePath = '$path/$fileName';

      await _client.storage
          .from(_bucketName)
          .upload(
            filePath,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Get public URL
      final String publicUrl = _client.storage
          .from(_bucketName)
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload file: ${e.toString()}');
    }
  }

  /// Upload multiple files
  Future<List<String>> uploadMultiple({
    required String basePath,
    required List<File> files,
  }) async {
    print(
      '🔧 SupabaseStorageService: Starting upload of ${files.length} files',
    );
    print('🔧 Bucket name: $_bucketName');
    print('🔧 Base path: $basePath');
    print('🔧 Supabase client is ready');

    // Check if bucket exists by trying to list files
    try {
      print('🔧 Testing bucket access...');
      await _client.storage.from(_bucketName).list();
      print('✅ Bucket access successful');
    } catch (e) {
      print('❌ Bucket access failed: $e');
      print(
        '❌ This likely means the bucket "$_bucketName" does not exist or you don\'t have permission',
      );
      throw Exception('Bucket access failed: ${e.toString()}');
    }

    final List<String> urls = [];

    for (int i = 0; i < files.length; i++) {
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'image_${timestamp}_$i.jpg';
      final String filePath = '$basePath/$fileName';

      print('🔧 Uploading file $i: $filePath');
      print('🔧 File exists: ${await files[i].exists()}');
      print('🔧 File size: ${await files[i].length()} bytes');

      try {
        print('🔧 Calling Supabase upload...');
        await _client.storage
            .from(_bucketName)
            .upload(
              filePath,
              files[i],
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: false,
              ),
            );

        print('🔧 Upload successful, getting public URL...');
        final String publicUrl = _client.storage
            .from(_bucketName)
            .getPublicUrl(filePath);
        print('🔧 Public URL: $publicUrl');
        urls.add(publicUrl);
      } catch (e, stackTrace) {
        print('❌ Upload error for file $i: $e');
        print('❌ Error type: ${e.runtimeType}');
        print('❌ Stack trace: $stackTrace');
        throw Exception('Failed to upload file $i: ${e.toString()}');
      }
    }

    print('✅ All uploads completed. Total URLs: ${urls.length}');
    return urls;
  }

  /// Delete a file from storage
  Future<void> delete(String path) async {
    try {
      await _client.storage.from(_bucketName).remove([path]);
    } catch (e) {
      throw Exception('Failed to delete file: ${e.toString()}');
    }
  }
}
