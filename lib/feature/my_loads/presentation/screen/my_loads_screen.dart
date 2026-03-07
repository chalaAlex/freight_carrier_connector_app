import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/cofig/string_manager.dart';
import 'package:flutter/material.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';

class MyLoadsScreen extends StatefulWidget {
  const MyLoadsScreen({super.key});

  @override
  State<MyLoadsScreen> createState() => _MyLoadsScreenState();
}

class _MyLoadsScreenState extends State<MyLoadsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          'My Loads',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.black),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: AppColors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.grey,
              labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'Onbidding'),
                Tab(text: 'Completed'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildActiveTab(), _buildPendingTab(), _buildCompletedTab()],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildActiveTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildLoadCard(
          imageUrl: 'https://via.placeholder.com/150',
          status: 'IN TRANSIT',
          statusColor: AppColors.primary,
          trackingNumber: '#BK-92841',
          fromCity: 'Chicago, IL',
          toCity: 'Los Angeles, CA',
          price: '\$3,450',
        ),
        const SizedBox(height: 16),
        _buildLoadCard(
          imageUrl: 'https://via.placeholder.com/150',
          status: 'PICKED UP',
          statusColor: AppColors.success,
          trackingNumber: '#BK-02855',
          fromCity: 'Houston, TX',
          toCity: 'Phoenix, AZ',
          price: '\$1,820',
        ),
        const SizedBox(height: 16),
        _buildLoadCard(
          imageUrl: 'https://via.placeholder.com/150',
          status: 'ARRIVED',
          statusColor: AppColors.secondary,
          trackingNumber: '#BK-92812',
          fromCity: 'Miami, FL',
          toCity: 'Atlanta, GA',
          price: '\$2,100',
        ),
      ],
    );
  }

  Widget _buildPendingTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: AppColors.grey.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No pending loads',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your pending loads will appear here',
            style: TextStyle(fontSize: 14, color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: AppColors.grey.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No completed loads',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your completed loads will appear here',
            style: TextStyle(fontSize: 14, color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadCard({
    required String imageUrl,
    required String status,
    required Color statusColor,
    required String trackingNumber,
    required String fromCity,
    required String toCity,
    required String price,
  }) {
    return Container(
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
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.reviewDriver);
        },
        borderRadius: BorderRadius.circular(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                width: 130,
                height: 160,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 130,
                    height: 170,
                    color: AppColors.lightGrey,
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      size: 40,
                      color: AppColors.grey,
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trackingNumber,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 8,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            fromCity,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 8,
                          color: AppColors.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            toCity,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TOTAL PRICE',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.grey,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              price,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.pushNamed(context, Routes.postFreightRoute);
      },
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      icon: const Icon(Icons.add),
      label: const Text(StringManager.postFreight),
    );
  }
}
