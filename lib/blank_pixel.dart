import 'package:flutter/material.dart';

class BlankPixel extends StatelessWidget {
  const BlankPixel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
