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

      print(publicUrl);

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
    try {
      await _client.storage.from(_bucketName).list();
    } catch (e) {
      throw Exception('Bucket access failed: ${e.toString()}');
    }

    final List<String> urls = [];

    for (int i = 0; i < files.length; i++) {
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'image_${timestamp}_$i.jpg';
      final String filePath = '$basePath/$fileName';
      try {
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

        final String publicUrl = _client.storage
            .from(_bucketName)
            .getPublicUrl(filePath);
        urls.add(publicUrl);
      } catch (e) {
        throw Exception('Failed to upload file $i: ${e.toString()}');
      }
    }
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
