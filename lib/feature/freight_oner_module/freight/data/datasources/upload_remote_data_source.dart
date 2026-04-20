import 'dart:io';

abstract class FileRemoteDataSource {
  Future<String> uploadFile({required String path, required File file});
  Future<List<String>> uploadMultipleFiles({
    required String basePath,
    required List<File> files,
  });
}
