import 'package:flutter/material.dart';

class FoodPixel extends StatelessWidget {
  const FoodPixel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(0, 255, 195, 171),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              '🍎',
              style: TextStyle(
                fontSize: 27,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          )),
    );
  }
}
