import 'package:flutter/material.dart';

class CarrierHomePage extends StatefulWidget {
  const CarrierHomePage({super.key});

  @override
  State<CarrierHomePage> createState() => _CarrierHomePageState();
}

class _CarrierHomePageState extends State<CarrierHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Carrier Home Page"),
      ),
    );
  }
}