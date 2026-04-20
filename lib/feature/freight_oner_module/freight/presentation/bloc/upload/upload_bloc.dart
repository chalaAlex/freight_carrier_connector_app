import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/usecases/upload_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/upload/upload_event.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/upload/upload_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final UploadFileUseCase uploadFileUseCase;
  final UploadMultipleFilesUseCase uploadMultipleFilesUseCase;

  UploadBloc({
    required this.uploadFileUseCase,
    required this.uploadMultipleFilesUseCase,
  }) : super(const UploadInitial()) {
    on<UploadSingleFileEvent>(_onUploadSingleFile);
    on<UploadMultipleFilesEvent>(_onUploadMultipleFiles);
    on<ResetUploadEvent>(_onResetUpload);
  }

  Future<void> _onUploadSingleFile(
    UploadSingleFileEvent event,
    Emitter<UploadState> emit,
  ) async {
    emit(const UploadLoading(currentIndex: 0, totalFiles: 1));

    try {
      final result = await uploadFileUseCase(
        UploadFileParams(path: event.path, file: event.file),
      );
      result.fold(
        (Failure failure) => emit(UploadError(message: failure.message)),
        (String url) => emit(UploadSuccess(uploadedUrls: [url])),
      );
    } catch (e) {
      throw Exception('Failed to delete file: ${e.toString()}');
    }
  }

  Future<void> _onUploadMultipleFiles(
    UploadMultipleFilesEvent event,
    Emitter<UploadState> emit,
  ) async {
    emit(UploadLoading(currentIndex: 0, totalFiles: event.files.length));

    try {
      final result = await uploadMultipleFilesUseCase(
        UploadMultipleFilesParams(basePath: event.basePath, files: event.files),
      );
      result.fold(
        (Failure failure) => emit(UploadError(message: failure.message)),
        (List<String> urls) => emit(UploadSuccess(uploadedUrls: urls)),
      );
    } catch (e) {
      throw Exception('Failed to delete file: ${e.toString()}');
    }
  }

  Future<void> _onResetUpload(
    ResetUploadEvent event,
    Emitter<UploadState> emit,
  ) async {
    emit(const UploadInitial());
  }
}
