import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:flutter/material.dart';

class FreightHomePage extends StatefulWidget {
  const FreightHomePage({super.key});

  @override
  State<FreightHomePage> createState() => _FreightHomePageState();
}

class _FreightHomePageState extends State<FreightHomePage> {
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(children: [
        
        ],
      ),
    );
  }
}
