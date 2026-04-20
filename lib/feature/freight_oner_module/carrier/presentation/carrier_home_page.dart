import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/feature/notifications/presentation/bloc/notification_bloc.dart';
import 'package:clean_architecture/feature/notifications/presentation/bloc/notification_state.dart';

class CarrierHomePage extends StatefulWidget {
  const CarrierHomePage({super.key});

  @override
  State<CarrierHomePage> createState() => _CarrierHomePageState();
}

class _CarrierHomePageState extends State<CarrierHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              final unreadCount = state is NotificationLoaded
                  ? state.unreadCount
                  : 0;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () =>
                        Navigator.pushNamed(context, Routes.notificationRoute),
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Badge(
                        label: Text('$unreadCount'),
                        backgroundColor: AppColors.error,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Center(child: Text('List of freights')),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('Manage Drivers'),
              subtitle: const Text('View and manage your fleet drivers'),
              trailing: const Icon(Icons.chevron_right),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.black12),
              ),
              onTap: () =>
                  Navigator.pushNamed(context, Routes.driverListScreen),
            ),
          ),
        ],
      ),
    );
  }
}
