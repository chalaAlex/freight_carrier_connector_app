import 'dart:io';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight/data/datasources/upload_remote_data_source.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/upload_repository.dart';
import 'package:dartz/dartz.dart';

class FileRepositoryImpl implements FileRepository {
  final FileRemoteDataSource remoteDataSource;

  FileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> uploadFile({
    required String path,
    required File file,
  }) async {
    try {
      final result = await remoteDataSource.uploadFile(path: path, file: file);
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadMultipleFiles({
    required String basePath,
    required List<File> files,
  }) async {
    try {
      print('📦 Repository: Calling remote data source...');
      final result = await remoteDataSource.uploadMultipleFiles(
        basePath: basePath,
        files: files,
      );
      print('📦 Repository: Upload successful, got ${result.length} URLs');
      return Right(result);
    } catch (error, stackTrace) {
      print('❌ Repository error: $error');
      print('❌ Error type: ${error.runtimeType}');
      print('❌ Stack trace: $stackTrace');
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
