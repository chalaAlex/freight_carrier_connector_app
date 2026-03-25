import 'package:equatable/equatable.dart';

class SubmitReviewParams extends Equatable {
  final String shipmentRequestId;
  final int rating;
  final String? comment;

  const SubmitReviewParams({
    required this.shipmentRequestId,
    required this.rating,
    this.comment,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'shipmentRequestId': shipmentRequestId,
      'rating': rating,
    };
    if (comment != null && comment!.isNotEmpty) {
      map['comment'] = comment;
    }
    return map;
  }

  @override
  List<Object?> get props => [shipmentRequestId, rating, comment];
}
