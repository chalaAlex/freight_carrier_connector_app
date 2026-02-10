import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class AnimatedDecorativeElement extends StatelessWidget {
  final double? left;
  final double? right;
  final double top;
  final double width;
  final double height;
  final String image;
  final int delayMs;

  const AnimatedDecorativeElement({
    super.key,
    this.left,
    this.right,
    required this.top,
    required this.width,
    required this.height,
    required this.image,
    required this.delayMs,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      child: FadeInDown(
        duration: Duration(milliseconds: delayMs),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
