import 'dart:io';
import 'package:clean_architecture/core/storage/supabase_storage_service.dart';
import 'package:clean_architecture/feature/freight/data/datasources/upload_remote_data_source.dart';

class FileRemoteDataSourceImpl implements FileRemoteDataSource {
  final SupabaseStorageService storageService;

  FileRemoteDataSourceImpl(this.storageService);

  @override
  Future<String> uploadFile({required String path, required File file}) async {
    return await storageService.upload(path: path, file: file);
  }

  @override
  Future<List<String>> uploadMultipleFiles({
    required String basePath,
    required List<File> files,
  }) async {
    return await storageService.uploadMultiple(
      basePath: basePath,
      files: files,
    );
  }
}
