import 'package:equatable/equatable.dart';

abstract class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object?> get props => [];
}

class UploadInitial extends UploadState {
  const UploadInitial();
}

class UploadLoading extends UploadState {
  final int currentIndex;
  final int totalFiles;

  const UploadLoading({required this.currentIndex, required this.totalFiles});

  @override
  List<Object?> get props => [currentIndex, totalFiles];
}

class UploadSuccess extends UploadState {
  final List<String> uploadedUrls;

  const UploadSuccess({required this.uploadedUrls});

  @override
  List<Object?> get props => [uploadedUrls];
}

class UploadError extends UploadState {
  final String message;

  const UploadError({required this.message});

  @override
  List<Object?> get props => [message];
}
