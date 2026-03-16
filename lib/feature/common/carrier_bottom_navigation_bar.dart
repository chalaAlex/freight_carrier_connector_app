import 'package:clean_architecture/feature/landing/presentation/screen/landing_page.dart';
import 'package:clean_architecture/feature/my_loads/presentation/screen/my_loads_screen.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/screens/carrier_listing_screen.dart';
import 'package:flutter/material.dart';

class CarrierBottomNavigationBar extends StatefulWidget {
  const CarrierBottomNavigationBar({super.key});

  @override
  State<CarrierBottomNavigationBar> createState() =>
      _CarrierBottomNavigationBarState();
}

class _CarrierBottomNavigationBarState
    extends State<CarrierBottomNavigationBar> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const LandingPage(),
    const CarrierListingScreen(),
    MyLoadsScreen(),
    MyLoadsScreen(),
    MyLoadsScreen(),
    MyLoadsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          elevation: 1,
          height: 60,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 0;
                  });
                },
                icon: Icon(
                  Icons.home,
                  size: 30,
                  color: currentIndex == 0
                      ? Colors.blueAccent
                      : Colors.grey.shade400,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 1;
                  });
                },
                icon: Icon(
                  Icons.fire_truck,
                  size: 30,
                  color: currentIndex == 1
                      ? Colors.blueAccent
                      : Colors.grey.shade400,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 2;
                  });
                },
                icon: Icon(
                  Icons.car_crash_sharp,
                  size: 30,
                  color: currentIndex == 2
                      ? Colors.blueAccent
                      : Colors.grey.shade400,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 3;
                  });
                },
                icon: Icon(
                  Icons.person,
                  size: 30,
                  color: currentIndex == 3
                      ? Colors.blueAccent
                      : Colors.grey.shade400,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 4;
                  });
                },
                icon: Icon(
                  Icons.person,
                  size: 30,
                  color: currentIndex == 4
                      ? Colors.blueAccent
                      : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
        body: screens[currentIndex],
      ),
    );
  }
}
