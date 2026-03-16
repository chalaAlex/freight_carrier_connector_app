import 'package:flutter/material.dart';

class FreightBottomNavigationBar extends StatefulWidget {
  const FreightBottomNavigationBar({super.key});

  @override
  State<FreightBottomNavigationBar> createState() =>
      _FreightBottomNavigationBarState();
}

class _FreightBottomNavigationBarState
    extends State<FreightBottomNavigationBar> {
  int currentIndex = 0;

  final List<Widget> screens = [
   
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
                  Icons.group,
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
            ],
          ),
        ),
        body: screens[currentIndex],
      ),
    );
  }
}
