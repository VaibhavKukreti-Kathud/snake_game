import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
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

enum SnakeDirections { UP, DOWN, LEFT, RIGHT }

class _HomeState extends State<Home> {
  int score = 0;
  AudioPlayer audioPlayer = AudioPlayer();

  //grid dimensions
  int rowSize = 10;
  int totalSquares = 100;

  bool isGameStarted = false;

  //snake position
  List<int> snakePosition = [
    0,
    1,
    2,
  ];

  //snake direction
  SnakeDirections currentDirection = SnakeDirections.RIGHT;

  int foodPosition = Random().nextInt(56);

  void startGame(BuildContext context) {
    Timer.periodic(Duration(milliseconds: 250), (timer) {
      setState(() {
        eatFood();
        moveSnake();
        if (checkCollision()) {
          timer.cancel();
          if (snakePosition.length == totalSquares) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Nahi! mai nahi maanta!'),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Game baj gaya!'),
              ),
            );
          }
          endGame();
          isGameStarted = false;
        }
      });
    });
  }

  bool checkCollision() {
    List snakeBody = snakePosition.sublist(0, snakePosition.length - 1);
    if (snakeBody.contains(snakePosition.last)) {
      return true;
    } else {
      return false;
    }
  }

  void endGame() {
    snakePosition = [0, 1, 2];
    currentDirection = SnakeDirections.RIGHT;
    generateFood();
  }

  void eatFood() {
    if (snakePosition.last == foodPosition) {
      snakePosition.insert(snakePosition.length - 1, foodPosition);
      score++;
      generateFood();
    }
  }

  void generateFood() {
    while (snakePosition.contains(foodPosition)) {
      foodPosition = Random().nextInt(totalSquares - 1);
    }
  }

  void moveSnake() {
    switch (currentDirection) {
      case SnakeDirections.UP:
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
      case SnakeDirections.DOWN:
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
      case SnakeDirections.LEFT:
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
      case SnakeDirections.RIGHT:
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 0 &&
              (currentDirection != SnakeDirections.LEFT)) {
            currentDirection = SnakeDirections.RIGHT;
          } else if (details.delta.dx < 0 &&
              (currentDirection != SnakeDirections.RIGHT)) {
            currentDirection = SnakeDirections.LEFT;
          }
        },
        onVerticalDragUpdate: (details) {
          if (isGameStarted) {
            if (details.delta.dy > 0 &&
                (currentDirection != SnakeDirections.UP)) {
              currentDirection = SnakeDirections.DOWN;
            } else if (details.delta.dy < 0 &&
                (currentDirection != SnakeDirections.DOWN)) {
              currentDirection = SnakeDirections.UP;
            }
          } else {}
        },
        child: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: GridView.builder(
                      itemCount: totalSquares,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: rowSize,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        if (snakePosition.contains(index)) {
                          if (snakePosition.last == index) {
                            return Padding(
                              padding: EdgeInsets.all(2),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 55, 255, 0),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Column(children: [
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ]),
                              ),
                            );
                          } else {
                            return SnakePixel();
                          }
                        } else if (foodPosition == index) {
                          return FoodPixel();
                        } else {
                          return BlankPixel();
                        }
                      }),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: !isGameStarted
                    ? MaterialButton(
                        onPressed: () {
                          setState(() {
                            isGameStarted = true;
                          });
                          startGame(context);
                        },
                        color: Colors.blue,
                        child: Text(
                          'Start',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
