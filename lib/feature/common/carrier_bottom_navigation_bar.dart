import 'package:clean_architecture/feature/carrier/presentation/carrier_home_page.dart';
import 'package:clean_architecture/feature/freight/presentation/freight_home_page.dart';
import 'package:flutter/material.dart';

class CarrierBottomNavigationBar extends StatefulWidget {
  const CarrierBottomNavigationBar({super.key});

  @override
  State<CarrierBottomNavigationBar> createState() =>
      _CarrierBottomNavigationBar();
}

class _CarrierBottomNavigationBar extends State<CarrierBottomNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [FreightHomePage(), CarrierHomePage()];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_outlined),
            activeIcon: Icon(Icons.local_shipping),
            label: 'Freights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Post',
          ),
        ],
      ),
    );
  }
}
