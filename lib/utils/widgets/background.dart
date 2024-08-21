import 'package:flutter/material.dart';

// Wrap your Scaffold with this widget to add background image
class BaseWidget extends StatelessWidget {
  final Widget child;
  const BaseWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage(""),
          opacity: 0.02,
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
