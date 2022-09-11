import 'package:flutter/material.dart';
import 'package:tic_tac_toe/ui/theme/color.dart';

import 'utils/game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: GameScreen());
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String lastValue = "X";
  bool gameOver = false;
  Game game = Game();

  int turn = 0;
  String result = "";

  List<int> scoreBoard = [0, 0, 0, 0, 0, 0, 0, 0];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    game.board = Game.initGameBoard();
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: MainColor.primaryColor,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "It's ${lastValue} turn".toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 58),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: boardWidth,
                height: boardWidth,
                child: GridView.count(
                  crossAxisCount: Game.boardLength ~/ 3,
                  padding: const EdgeInsets.all(16),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: List.generate(Game.boardLength, (index) {
                    return InkWell(
                      onTap: gameOver
                          ? null
                          : () {
                              if (game.board![index] == "") {
                                setState((() {
                                  game.board![index] = lastValue;
                                  turn++;
                                  gameOver = game.winnerCheck(
                                      lastValue, index, scoreBoard, 3);
                                  if (gameOver) {
                                    result = "${lastValue} won";
                                  } else if (turn == 9) {
                                    gameOver = true;
                                    result = "Draw";
                                  } else {
                                    lastValue = lastValue == "X" ? "O" : "X";
                                  }
                                }));
                              }
                            },
                      child: Container(
                          decoration: BoxDecoration(
                              color: MainColor.secondaryColor,
                              borderRadius: BorderRadius.circular(16)),
                          width: Game.blocSize,
                          height: Game.blocSize,
                          child: Center(
                              child: Text(
                            game.board![index],
                            style: TextStyle(
                                color: game.board![index] == "X"
                                    ? Colors.blue
                                    : Colors.pink,
                                fontSize: 58),
                          ))),
                    );
                  }),
                ),
              ),
              Text(
                result,
                style: const TextStyle(color: Colors.white, fontSize: 58.0),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    game.board = Game.initGameBoard();
                    gameOver = false;
                    turn = 0;
                    result = "";
                    scoreBoard = [0, 0, 0, 0, 0, 0, 0, 0];
                  });
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                icon: const Icon(Icons.replay),
                label: const Text("Repeat the Game"),
              )
            ]));
  }
}
