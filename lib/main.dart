import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_game/blank_pixel.dart';
import 'package:snake_game/snake_pixel.dart';

import 'food_pixel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

enum snakeDirections { UP, DOWN, LEFT, RIGHT }

class _HomeState extends State<Home> {
  //grid dimensions
  int rowSize = 10;
  int totalSquares = 100;

  //snake position
  List<int> snakePosition = [
    0,
    1,
    2,
  ];

  //snake direction
  snakeDirections currentDirection = snakeDirections.RIGHT;

  int foodPosition = Random().nextInt(99);

  void startGame(BuildContext context) {
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        eatFood();
        moveSnake();
        List snakeBody = snakePosition.sublist(0, snakePosition.length - 1);
        if (snakeBody.contains(snakePosition.last)) {
          timer.cancel();
          if (snakePosition.length == totalSquares) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You won!'),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You lost!'),
              ),
            );
          }
          endGame();
        }
      });
    });
  }

  void endGame() {
    snakePosition = [0, 1, 2];
    currentDirection = snakeDirections.RIGHT;
    generateFood();
  }

  void eatFood() {
    if (snakePosition.last == foodPosition) {
      snakePosition.insert(snakePosition.length - 1, foodPosition);
      generateFood();
    }
  }

  void generateFood() {
    foodPosition = Random().nextInt(99);
  }

  void moveSnake() {
    switch (currentDirection) {
      case snakeDirections.UP:
        {
          if (snakePosition.last < rowSize) {
            snakePosition.add(snakePosition.last + (totalSquares - rowSize));
            snakePosition.removeAt(0);
          } else {
            snakePosition.add(snakePosition.last - rowSize);
            snakePosition.removeAt(0);
          }
        }
        break;
      case snakeDirections.DOWN:
        {
          if (snakePosition.last > totalSquares - rowSize) {
            snakePosition.add(snakePosition.last - (totalSquares - rowSize));
            snakePosition.removeAt(0);
          } else {
            snakePosition.add(snakePosition.last + rowSize);
            snakePosition.removeAt(0);
          }
        }
        break;
      case snakeDirections.LEFT:
        {
          if (snakePosition.last % rowSize == 0) {
            snakePosition.add(snakePosition.last + (rowSize - 1));
            snakePosition.removeAt(0);
          } else {
            snakePosition.add(snakePosition.last - 1);
            snakePosition.removeAt(0);
          }
        }
        break;
      case snakeDirections.RIGHT:
        {
          if (snakePosition.last % rowSize == rowSize - 1) {
            snakePosition.add(snakePosition.last - (rowSize - 1));
            snakePosition.removeAt(0);
          } else {
            snakePosition.add(snakePosition.last + 1);
            snakePosition.removeAt(0);
          }
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 &&
                    (currentDirection != snakeDirections.LEFT)) {
                  currentDirection = snakeDirections.RIGHT;
                } else if (details.delta.dx < 0 &&
                    (currentDirection != snakeDirections.RIGHT)) {
                  currentDirection = snakeDirections.LEFT;
                }
              },
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 &&
                    (currentDirection != snakeDirections.UP)) {
                  currentDirection = snakeDirections.DOWN;
                } else if (details.delta.dy < 0 &&
                    (currentDirection != snakeDirections.DOWN)) {
                  currentDirection = snakeDirections.UP;
                }
              },
              child: GridView.builder(
                  itemCount: totalSquares,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowSize,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (snakePosition.contains(index)) {
                      return SnakePixel();
                    } else if (foodPosition == index) {
                      return FoodPixel();
                    } else {
                      return BlankPixel();
                    }
                  }),
            ),
          ),
          Expanded(
            child: Center(
              child: MaterialButton(
                onPressed: () {
                  startGame(context);
                },
                color: Colors.blue,
                child: Text(
                  'Start',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
