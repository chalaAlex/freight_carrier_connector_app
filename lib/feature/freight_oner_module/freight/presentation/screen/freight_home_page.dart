import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/routes_manager.dart';

/// Freight owner home page with navigation to truck listing
class FreightHomePage extends StatelessWidget {
  const FreightHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Freight Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to truck listing screen
            Navigator.of(context).pushNamed(Routes.truckListingRoute);
          },
          child: const Text('View Available Trucks'),
        ),
      ),
    );
  }
}
