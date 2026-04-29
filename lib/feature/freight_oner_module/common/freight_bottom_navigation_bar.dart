import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/presentation/screen/my_bids_screen.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/presentation/screen/my_carriers_screen.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/presentation/screen/driver_list_screen.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freight_home_page/presentation/screen/freight_listing.dart';
import 'package:clean_architecture/feature/chat/presentation/bloc/inbox/inbox_bloc.dart';
import 'package:clean_architecture/feature/chat/presentation/bloc/inbox/inbox_event.dart';
import 'package:clean_architecture/feature/chat/presentation/screens/inbox_screen.dart';
import 'package:clean_architecture/feature/freight_oner_module/common/app_drawer.dart';
import 'package:clean_architecture/feature/payment/presentation/screen/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FreightBottomNavigationBar extends StatefulWidget {
  const FreightBottomNavigationBar({super.key});

  @override
  State<FreightBottomNavigationBar> createState() =>
      _FreightBottomNavigationBarState();
}

class _FreightBottomNavigationBarState
    extends State<FreightBottomNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FreightListingScreen(),
    const MyCarriersScreen(),
    const DriverListScreen(),
    const MyBidsScreen(),
    const InboxScreen(),
    const WalletScreen(),
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
                  size: 30,
                  color: _currentIndex == 0
                      ? context.appColors.primary
                      : context.appColors.textSecondary,
                ),
                tooltip: 'Home',
              ),
              IconButton(
                onPressed: () => _onTabTapped(1),
                icon: Icon(
                  Icons.local_shipping_outlined,
                  size: 30,
                  color: _currentIndex == 1
                      ? context.appColors.primary
                      : context.appColors.textSecondary,
                ),
                tooltip: 'My Carriers',
              ),
              IconButton(
                onPressed: () => _onTabTapped(2),
                icon: Icon(
                  Icons.people_outline,
                  size: 30,
                  color: _currentIndex == 2
                      ? context.appColors.primary
                      : context.appColors.textSecondary,
                ),
                tooltip: 'My Drivers',
              ),
              IconButton(
                onPressed: () => _onTabTapped(3),
                icon: Icon(
                  Icons.gavel_outlined,
                  size: 30,
                  color: _currentIndex == 3
                      ? context.appColors.primary
                      : context.appColors.textSecondary,
                ),
                tooltip: 'My Bids',
              ),
              IconButton(
                onPressed: () => _onTabTapped(4),
                icon: Icon(
                  Icons.chat_bubble_outline,
                  size: 30,
                  color: _currentIndex == 4
                      ? context.appColors.primary
                      : context.appColors.textSecondary,
                ),
                tooltip: 'Messages',
              ),
              IconButton(
                onPressed: () => _onTabTapped(5),
                icon: Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 30,
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
