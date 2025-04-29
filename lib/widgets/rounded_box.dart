import 'package:flutter/material.dart';

class RoundedBox extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsets padding;
  final Color? color;
  final Color? outlineColor;
  final double outlineStroke;
  final double borderRadius;

  const RoundedBox({
    Key? key,
    this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(8),
    this.color = Colors.white,
    this.outlineColor = Colors.grey,
    this.outlineStroke = 0.5,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: outlineColor ?? Colors.black, width: outlineStroke),
      ),
      child: child,
    );
  }
}