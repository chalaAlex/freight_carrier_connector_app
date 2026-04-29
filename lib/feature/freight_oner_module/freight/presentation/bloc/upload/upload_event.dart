import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object?> get props => [];
}

class UploadSingleFileEvent extends UploadEvent {
  final File file;
  final String path;

  const UploadSingleFileEvent({required this.file, required this.path});

  @override
  List<Object?> get props => [file, path];
}

class UploadMultipleFilesEvent extends UploadEvent {
  final List<File> files;
  final String basePath;

  const UploadMultipleFilesEvent({required this.files, required this.basePath});

  @override
  List<Object?> get props => [files, basePath];
}

class ResetUploadEvent extends UploadEvent {
  const ResetUploadEvent();
}
