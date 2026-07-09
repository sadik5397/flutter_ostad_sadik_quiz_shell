import 'package:flutter/material.dart';

class ShimmerBlock extends StatelessWidget {
  const ShimmerBlock({super.key, required this.height, required this.radius});

  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(radius)),
    );
  }
}
