import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memory_game_getx/features/game_card/game_card.dart';
import 'main_game_controller.dart';

class MainGameScreen extends StatelessWidget {
  final mainGameController = Get.put(MainGameController());

  MainGameScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (mainGameController.isGameOver()) Future.microtask(() => showGameOverEndPlayAgainButtonDialog(context, mainGameController));
        return Scaffold(
          backgroundColor: mainGameController.backGroundColorForTurnState(),
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Ali: ${mainGameController.aliScore.toInt()}'),
                Text('Sebnem: ${mainGameController.sebnemScore.toInt()}'),
              ],
            ),
          ),
          body: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            children: List.generate(
              mainGameController.gameCardList.length,
              (index) => GameCard(
                gameCardModel: mainGameController.gameCardList[index],
              ),
            ),
          ),
        );
      },
    );
  }

  void showGameOverEndPlayAgainButtonDialog(BuildContext context, MainGameController mainGameController) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text(mainGameController.showWinner()),
          actions: [
            TextButton(
              onPressed: () {
                mainGameController.resetGame();
                Navigator.of(context).pop();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }
}
