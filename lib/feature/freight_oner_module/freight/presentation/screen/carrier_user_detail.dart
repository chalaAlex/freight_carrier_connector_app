import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';

class CarrierUserDetail extends StatelessWidget {
  const CarrierUserDetail({super.key});

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
          'Owner Profile',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildAboutSection(),
            const SizedBox(height: 24),
            _buildAvailableTrucks(context),
            const SizedBox(height: 24),
            _buildRecentReviews(context),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: _buildMessageButton(context),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.lightGrey, width: 2),
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://via.placeholder.com/100',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.lightGrey,
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'John Doe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: AppColors.warning, size: 20),
              const SizedBox(width: 4),
              const Text(
                '4.8',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '• 120 reviews',
                style: TextStyle(fontSize: 14, color: AppColors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Member since 2019',
            style: TextStyle(fontSize: 14, color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Professional logistics operator with over 15 years of experience in regional and long-haul transportation. I specialize in heavy-duty freight and temperature-controlled logistics. My fleet is maintained to the highest safety standards.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.darkGrey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableTrucks(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.truckDetailRoute);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Available Trucks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  '3 Total',
                  style: TextStyle(fontSize: 14, color: AppColors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildTruckCard(
                    'Volvo VNL 860',
                    '45,000 lbs capacity',
                    'https://via.placeholder.com/150x100',
                  ),
                  const SizedBox(width: 12),
                  _buildTruckCard(
                    'Freightliner',
                    '40,000 lbs capacity',
                    'https://via.placeholder.com/150x100',
                  ),
                  const SizedBox(width: 12),
                  _buildTruckCard(
                    'Kenworth T680',
                    '42,000 lbs capacity',
                    'https://via.placeholder.com/150x100',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTruckCard(String name, String capacity, String imageUrl) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 100,
              width: 160,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100,
                  color: AppColors.primary.withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.local_shipping,
                    size: 40,
                    color: AppColors.primary,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.scale, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        capacity,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGrey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

  Widget _buildRecentReviews(BuildContext context) {
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
                'Recent Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.viewAllReiviews);
                },
                child: const Text(
                  'View all',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildReviewCard(
            'Mike R.',
            'Freight Owner',
            '3 days ago',
            5,
            '"John was fantastic! He arrived early for pickup and the goods were delivered in perfect condition. Highly recommend for anyone needing reliable transport."',
          ),
          const SizedBox(height: 16),
          _buildReviewCard(
            'Sarah L.',
            'Logistics Mgr',
            '1 week ago',
            4,
            '"Very professional and communicates well throughout the route. The real-time tracking updates were a huge plus for our team."',
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(
    String name,
    String role,
    String time,
    int rating,
    String review,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(
            5,
            (index) => Icon(
              index < rating ? Icons.star : Icons.star_border,
              color: AppColors.warning,
              size: 18,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          review,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.darkGrey,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.lightGrey,
              child: Text(
                name[0],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  Text(
                    role,
                    style: TextStyle(fontSize: 12, color: AppColors.grey),
                  ),
                ],
              ),
            ),
            Text(time, style: TextStyle(fontSize: 12, color: AppColors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildMessageButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.message, size: 20),
            label: const Text(
              'Message Owner',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}
