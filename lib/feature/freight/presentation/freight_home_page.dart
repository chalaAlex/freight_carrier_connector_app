import 'package:flutter/material.dart';

class FreightHomePage extends StatefulWidget {
  const FreightHomePage({super.key});

  @override
  State<FreightHomePage> createState() => _FreightHomePageState();
}

class _FreightHomePageState extends State<FreightHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Freight Page"),
      ),
    );
  }
}