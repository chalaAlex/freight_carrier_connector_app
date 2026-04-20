import 'package:clean_architecture/core/request/review_request.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/domain/entity/review_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/domain/usecases/submit_review_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class ReviewEvent extends Equatable {
  const ReviewEvent();
  @override
  List<Object?> get props => [];
}

class SubmitReviewEvent extends ReviewEvent {
  final String shipmentRequestId;
  final int rating;
  final String? comment;

  const SubmitReviewEvent({
    required this.shipmentRequestId,
    required this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [shipmentRequestId, rating, comment];
}

// States
abstract class ReviewState extends Equatable {
  const ReviewState();
  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {
  const ReviewInitial();
}

class ReviewSubmitting extends ReviewState {
  const ReviewSubmitting();
}

class ReviewSuccess extends ReviewState {
  final ReviewEntity review;
  const ReviewSuccess({required this.review});
  @override
  List<Object?> get props => [review];
}

class ReviewError extends ReviewState {
  final String message;
  const ReviewError({required this.message});
  @override
  List<Object?> get props => [message];
}

// BLoC
class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final SubmitReviewUseCase submitReviewUseCase;

  ReviewBloc({required this.submitReviewUseCase})
    : super(const ReviewInitial()) {
    on<SubmitReviewEvent>(_onSubmit);
  }

  Future<void> _onSubmit(
    SubmitReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    // Guard: ignore if already submitting
    if (state is ReviewSubmitting) return;

    emit(const ReviewSubmitting());
    final result = await submitReviewUseCase(
      SubmitReviewParams(
        shipmentRequestId: event.shipmentRequestId,
        rating: event.rating,
        comment: event.comment,
      ),
    );
    result.fold(
      (failure) => emit(ReviewError(message: failure.message)),
      (review) => emit(ReviewSuccess(review: review)),
    );
  }
}
