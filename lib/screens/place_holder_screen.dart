import 'package:flutter/material.dart';

class PlaceHolderScreen extends StatelessWidget {
  final String title;

  const PlaceHolderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}