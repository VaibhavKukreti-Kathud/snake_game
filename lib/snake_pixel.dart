import 'package:flutter/material.dart';

class SnakePixel extends StatelessWidget {
  const SnakePixel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}