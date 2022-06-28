import 'package:flutter/material.dart';
import 'dart:async';
// import 'package:dino/barrier.dart';
// import 'package:dino/taptoplay.dart';
// import 'dino.dart';
// import 'gameover.dart';
// import 'scorescreen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // dino variables (dari 2)
  double dinoX = -0.5;
  double dinoY = 1;
  double dinoWidth = 0.2;
  double dinoHeight = 0.4;

  // variabel penghalang (dari 2)
  double barrierX = 1;
  double barrierY = 1;
  double barrierWidth = 0.1;
  double barrierHeight = 0.4;

  // variabel lompatan
  double time = 0;
  double height = 0;
  double gravity = 9.8;   // gravitasi di kehidupan nyata 9.8
  double velocity = 5;    // kekuatan lompat

  // pengaturan game
  bool gameHasStarted = false;
  bool midJump = false;   // utk mencegah double jump
  bool gameOver = false;
  int score = 0;
  int highscore = 0;
  bool dinoPassedBarrier = false;

  // ini akan membuat map mulai bergerak
  // contohnya barriers akan memulai pergerakan
  void startGame(){
    setState(() {
      gameHasStarted = true;
    });

    Timer.periodic(Duration(milliseconds: 10), (timer) { 
      // cek apakah dino menabrak penghalang
      if (detectCollision()) {
        gameOver = true;
        timer.cancel();
        setState(() {
          if (score > highscore) {
            highscore = score;
          }
        });
      }

      // perulangan penghalang agar tetap berjalan di map
      loopBarriers();
      updateScore();

      setState(() {
        barrierX -= 0.01;
      });
    });
  }

  // untuk update score
  void updateScore(){}

  // perulangan penghalang
  void loopBarriers(){
    setState(() {
      if (barrierX <= -1.2) {
        barrierX = 1.2;
        dinoPassedBarrier = false;
      }
    });
  }

  // mendeteksi tabrakan penghalang
  bool detectCollision(){}

  // dino lompat
  void jump(){
    midJump = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) { 
      height = -gravity / 2 * time * time + velocity * time;

      setState(() {
        if (1 - height > 1) {
          resetJump();
          dinoY = 1;
          timer.cancel();
        } else {
          dinoY = 1 - height;
        }
      });
      // check if dead
      if (gameOver) {
        timer.cancel();
      }
      // kalo ga, waktu tetep jalan
      time += 0.01;
    });
  }

  void resetJump(){}

  void playAgain(){}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameOver
          ? (playAgain)
          : (gameHasStarted ? (midJump ? null : jump) : startGame),
      child: Scaffold(
          backgroundColor: Colors.grey[300],
          body: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Center(
                    child: Stack(
                      children: [
                        // tap to play
                        TapToPlay(
                          gameHasStarted: gameHasStarted,
                        ),

                        // game over screen
                        GameOverScreen(
                          gameOver: gameOver,
                        ),

                        // scores
                        ScoreScreen(
                          score: score,
                          highscore: highscore,
                        ),

                        // dino
                        MyDino(
                          dinoX: dinoX,
                          dinoY: dinoY - dinoHeight,
                          dinoWidth: dinoWidth,
                          dinoHeight: dinoHeight,
                        ),

                        MyBarrier(
                          barrierX: barrierX,
                          barrierY: barrierY - barrierHeight,
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
    );
  }
}
