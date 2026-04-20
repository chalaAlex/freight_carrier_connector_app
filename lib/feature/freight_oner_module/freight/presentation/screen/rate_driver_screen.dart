import 'package:flutter/material.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';

class RateDriverScreen extends StatefulWidget {
  const RateDriverScreen({super.key});

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  int _selectedRating = 0;
  final Set<String> _selectedTags = {};
  final TextEditingController _reviewController = TextEditingController();

  final List<String> _tags = [
    'On-time delivery',
    'Professionalism',
    'Great communication',
    'Safe handling',
  ];

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Rate Driver',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDriverInfo(),
              const SizedBox(height: 32),
              _buildRatingSection(),
              const SizedBox(height: 32),
              _buildWhatWentWellSection(),
              const SizedBox(height: 32),
              _buildReviewSection(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
              const SizedBox(height: 16),
              _buildFooterText(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDriverInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.lightGrey,
                child: ClipOval(
                  child: Image.network(
                    'https://via.placeholder.com/64',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 32,
                        color: AppColors.grey,
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Robert Sterling',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Booking #BK-92812',
                  style: TextStyle(fontSize: 14, color: AppColors.grey),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: AppColors.warning),
                    const SizedBox(width: 4),
                    const Text(
                      '4.9',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Column(
      children: [
        const Text(
          'How was your experience?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRating = index + 1;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.star,
                  size: 48,
                  color: index < _selectedRating
                      ? AppColors.warning
                      : AppColors.lightGrey,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        Text(
          'Tap to rate your delivery',
          style: TextStyle(fontSize: 14, color: AppColors.grey),
        ),
      ],
    );
  }

  Widget _buildWhatWentWellSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WHAT WENT WELL?',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _tags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedTags.remove(tag);
                  } else {
                    _selectedTags.add(tag);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.white : AppColors.white,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.secondary
                        : AppColors.lightGrey,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? AppColors.secondary
                        : AppColors.darkGrey,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WRITE A REVIEW',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightGrey),
          ),
          child: TextField(
            controller: _reviewController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'Tell us more about the service (optional)...',
              hintStyle: TextStyle(fontSize: 14, color: AppColors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(fontSize: 14, color: AppColors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _selectedRating > 0
            ? () {
                // Handle submit
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Review submitted successfully!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.lightGrey,
          disabledForegroundColor: AppColors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Submit Review',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFooterText() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Your feedback helps us maintain high quality standards for our logistics network.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppColors.grey, height: 1.5),
        ),
      ),
    );
  }
}
