import 'package:flutter/material.dart';
import '../theme/themeprov.dart';
import 'package:provider/provider.dart';

class NeuThinBoxWithGradient extends StatelessWidget {
  final Widget child; // Accept child in the constructor

  const NeuThinBoxWithGradient({super.key, required this.child}); // Constructor

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<Themeprov>(context, listen: false).isDark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [Colors.purple.shade800, Colors.orange.shade700] // Dark mode: purple to orange
              : [Colors.lime.shade300, Colors.lightBlue.shade100], // Light mode: lime green to light blue
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black : Colors.grey.shade500,
            blurRadius: 15,
            offset: const Offset(4, 4),
          ),
          BoxShadow(
            color: isDark ? Colors.grey.shade800 : Colors.white,
            blurRadius: 15,
            offset: const Offset(-4, -4),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(6),
      child: child,
    );
  }
}
