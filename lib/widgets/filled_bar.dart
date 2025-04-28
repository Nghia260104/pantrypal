import 'package:flutter/material.dart';

class FilledBar extends StatelessWidget {
  final double currentValue;
  final double maxValue;
  final Color? backgroundColor;
  final Color? fillColor;
  final double height;

  const FilledBar({
    super.key,
    required this.currentValue,
    required this.maxValue,
    this.backgroundColor = Colors.grey,
    this.fillColor = Colors.blue,
    this.height = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    double progress = (currentValue / maxValue).clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          // Background layer
          Container(
            height: height,
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
          ),
          // Filled portion layer
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              height: height,
              color: fillColor,
            ),
          ),
        ],
      ),
    );
  }
}
