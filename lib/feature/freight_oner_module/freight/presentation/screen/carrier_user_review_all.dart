import 'package:flutter/material.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';

class CarrierUserReviewAll extends StatefulWidget {
  const CarrierUserReviewAll({super.key});

  @override
  State<CarrierUserReviewAll> createState() => _CarrierUserReviewAllState();
}

class _CarrierUserReviewAllState extends State<CarrierUserReviewAll> {
  String selectedFilter = 'Most Recent';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reviews and Ratings',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRatingSummary(),
            const SizedBox(height: 16),
            _buildAllReviewsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const Text(
                  '4.8',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < 4 ? Icons.star : Icons.star_half,
                      color: AppColors.warning,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '120 Reviews',
                  style: TextStyle(fontSize: 14, color: AppColors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildRatingBar(5, 85),
                _buildRatingBar(4, 10),
                _buildRatingBar(3, 3),
                _buildRatingBar(2, 1),
                _buildRatingBar(1, 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, int percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$stars',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.darkGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage / 100,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllReviewsSection() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'All Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              _buildFilterButton(),
            ],
          ),
          const SizedBox(height: 20),
          _buildReviewCard(
            name: 'Mike R.',
            initials: 'MR',
            time: '2 days ago',
            rating: 5.0,
            review:
                'John was fantastic! He arrived early for pickup and the goods were delivered in perfect condition. Highly recommend for anyone needing reliable transport.',
            avatarColor: Colors.blue[700]!,
          ),
          const Divider(height: 32),
          _buildReviewCard(
            name: 'Sarah Jenkins',
            initials: 'SJ',
            time: '1 week ago',
            rating: 5.0,
            review:
                'Very professional service. The truck was clean and the driver helped with securing the load. Will definitely book again for my next shipment.',
            avatarColor: Colors.purple[300]!,
          ),
          const Divider(height: 32),
          _buildReviewCard(
            name: 'David Lee',
            initials: 'DL',
            time: '3 weeks ago',
            rating: 4.0,
            review:
                'Good communication throughout the trip. Arrived slightly later than estimated due to traffic, but everything was intact.',
            avatarColor: Colors.green[600]!,
          ),
          const Divider(height: 32),
          _buildReviewCard(
            name: 'Alex Martinez',
            initials: 'AM',
            time: '1 month ago',
            rating: 5.0,
            review:
                "Best freight experience I've had in a while. The Volvo is a beast and handled the heavy load perfectly.",
            avatarColor: Colors.orange[700]!,
          ),
          const Divider(height: 32),
          _buildReviewCard(
            name: 'Elena T.',
            initials: 'ET',
            time: '2 months ago',
            rating: 5.0,
            review: 'Smooth transaction. Highly recommended!',
            avatarColor: Colors.blue[400]!,
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return InkWell(
      onTap: () {
        _showFilterBottomSheet();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGrey),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.filter_list, size: 16, color: AppColors.darkGrey),
            const SizedBox(width: 6),
            Text(
              selectedFilter,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required String initials,
    required String time,
    required double rating,
    required String review,
    required Color avatarColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: avatarColor,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: AppColors.warning,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(fontSize: 12, color: AppColors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          review,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.darkGrey,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort by',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 16),
              _buildFilterOption('Most Recent'),
              _buildFilterOption('Highest Rating'),
              _buildFilterOption('Lowest Rating'),
              _buildFilterOption('Most Helpful'),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String option) {
    final isSelected = selectedFilter == option;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        option,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? AppColors.primary : AppColors.black,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check, color: AppColors.primary) : null,
      onTap: () {
        setState(() {
          selectedFilter = option;
        });
        Navigator.pop(context);
      },
    );
  }
}
