import 'package:clean_architecture/feature/rating_and_review/domain/entity/review_entity.dart';
import 'package:clean_architecture/feature/rating_and_review/presentation/bloc/review_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmitReviewScreen extends StatefulWidget {
  final CompletedShipmentEntity shipment;

  const SubmitReviewScreen({super.key, required this.shipment});

  @override
  State<SubmitReviewScreen> createState() => _SubmitReviewScreenState();
}

class _SubmitReviewScreenState extends State<SubmitReviewScreen> {
  int _selectedRating = 0;
  final _commentController = TextEditingController();
  String? _ratingError;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_selectedRating == 0) {
      setState(() => _ratingError = 'Please select a rating');
      return;
    }
    setState(() => _ratingError = null);

    context.read<ReviewBloc>().add(
      SubmitReviewEvent(
        shipmentRequestId: widget.shipment.id,
        rating: _selectedRating,
        comment: _commentController.text.trim().isEmpty
            ? null
            : _commentController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewBloc, ReviewState>(
      listener: (context, state) {
        if (state is ReviewSuccess) {
          Navigator.pop(context);
        } else if (state is ReviewError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Leave a Review')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carrier info
              Text(
                [
                  widget.shipment.carrierBrand,
                  widget.shipment.carrierModel,
                ].where((s) => s != null && s.isNotEmpty).join(' '),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (widget.shipment.plateNumber != null)
                Text(
                  widget.shipment.plateNumber!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              const SizedBox(height: 24),

              // Star rating
              const Text('Rating *'),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  final star = index + 1;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRating = star),
                    child: Icon(
                      star <= _selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    ),
                  );
                }),
              ),
              if (_ratingError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _ratingError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 24),

              // Comment field
              TextField(
                controller: _commentController,
                maxLength: 100,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Comment (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Submit button
              BlocBuilder<ReviewBloc, ReviewState>(
                builder: (context, state) {
                  final isSubmitting = state is ReviewSubmitting;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _onSubmit,
                      child: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Submit Review'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
