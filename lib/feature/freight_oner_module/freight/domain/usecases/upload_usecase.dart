import 'dart:io';
import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/repositories/upload_repository.dart';
import 'package:dartz/dartz.dart';

class UploadFileUseCase implements UseCase<String, UploadFileParams> {
  final FileRepository repository;

  UploadFileUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadFileParams params) {
    return repository.uploadFile(path: params.path, file: params.file);
  }
}

class UploadMultipleFilesUseCase
    implements UseCase<List<String>, UploadMultipleFilesParams> {
  final FileRepository repository;

  UploadMultipleFilesUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(UploadMultipleFilesParams params) {
    return repository.uploadMultipleFiles(
      basePath: params.basePath,
      files: params.files,
    );
  }
}

class UploadFileParams {
  final String path;
  final File file;

  UploadFileParams({required this.path, required this.file});
}

class UploadMultipleFilesParams {
  final String basePath;
  final List<File> files;

  UploadMultipleFilesParams({required this.basePath, required this.files});
}
