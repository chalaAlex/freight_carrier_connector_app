import 'dart:io';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class FileRepository {
  Future<Either<Failure, String>> uploadFile({
    required String path,
    required File file,
  });
  Future<Either<Failure, List<String>>> uploadMultipleFiles({
    required String basePath,
    required List<File> files,
  });
}
