import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/feature/chat/presentation/bloc/inbox/inbox_bloc.dart';
import 'package:clean_architecture/feature/chat/presentation/bloc/inbox/inbox_event.dart';
import 'package:clean_architecture/feature/chat/presentation/screens/inbox_screen.dart';
import 'package:clean_architecture/feature/freight_oner_module/common/app_drawer.dart';
import 'package:clean_architecture/feature/freight_oner_module/landing/presentation/screen/landing_page.dart';
import 'package:clean_architecture/feature/freight_oner_module/my_loads/presentation/screen/my_loads_screen.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/presentation/screen/shipment_request_home_page.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/presentation/screens/carrier_listing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarrierBottomNavigationBar extends StatefulWidget {
  const CarrierBottomNavigationBar({super.key});

  @override
  State<CarrierBottomNavigationBar> createState() =>
      _CarrierBottomNavigationBarState();
}

class _CarrierBottomNavigationBarState
    extends State<CarrierBottomNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const LandingPage(),
    const CarrierListingScreen(),
    MyLoadsScreen(),
    ShipmentRequestHomePage(),
    const InboxScreen(),
    // BlocProvider(create: (_) => sl<WalletBloc>(), child: const WalletScreen()),
  ];

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
    if (index == 4) {
      context.read<InboxBloc>().add(const LoadInbox());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          backgroundColor: context.appColors.surface,
          elevation: 0,
          title: const Text('Smart Truck'),
          actions: const [],
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 1,
          height: 60,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () => _onTabTapped(0),
                icon: Icon(
                  Icons.home,
                  size: 28,
                  color: _currentIndex == 0
                      ? context.appColors.primary
                      : context.appColors.textSecondary,
                ),
                tooltip: 'Home',
              ),
              IconButton(
                onPressed: () => _onTabTapped(1),
                icon: Icon(
                  Icons.fire_truck,
                  size: 28,
                  color: _currentIndex == 1
                      ? context.appColors.primary
                      : context.appColors.textSecondary,
                ),
                tooltip: 'Trucks',
              ),
              IconButton(
                onPressed: () => _onTabTapped(2),
                icon: Icon(
                  Icons.local_shipping_outlined,
                  size: 28,
                  color: _currentIndex == 2
                      ? context.appColors.primary
                      : context.appColors.textSecondary,
                ),
                tooltip: 'My Carriers',
              ),
              IconButton(
                onPressed: () => _onTabTapped(3),
                icon: Icon(
                  Icons.inventory_2_outlined,
                  size: 28,
                  color: _currentIndex == 3
                      ? context.appColors.primary
                      : context.appColors.textSecondary,
                ),
                tooltip: 'My Loads',
              ),
              IconButton(
                onPressed: () => _onTabTapped(4),
                icon: Icon(
                  Icons.message,
                  size: 28,
                  color: _currentIndex == 4
                      ? context.appColors.primary
                      : context.appColors.textSecondary,
                ),
                tooltip: 'Requests',
              ),
              IconButton(
                onPressed: () => _onTabTapped(5),
                icon: Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 28,
                  color: _currentIndex == 5
                      ? context.appColors.primary
                      : context.appColors.textSecondary,
                ),
                tooltip: 'Wallet',
              ),
            ],
          ),
        ),
        body: IndexedStack(index: _currentIndex, children: _screens),
      ),
    );
  }
}
