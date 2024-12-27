import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memory_game_getx/features/main_game/main_game_controller.dart';

import '../../core/model/game_card_model.dart';
import 'game_card_controller.dart';

class GameCard extends StatelessWidget {
  GameCardModel gameCardModel;
  GameCard({super.key, required this.gameCardModel});
  final GameCardController gameCardController = Get.put(GameCardController(), tag: UniqueKey().toString());
  final MainGameController mainGameController = Get.find<MainGameController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Card(
          color: gameCardController.isFlippedOrMatch(gameCardModel),
          child: Obx(() => InkWell(
                onTap: gameCardModel.isFlipped.value
                    ? null
                    : mainGameController.gameState.value == MainGameState.secondCardFlipped
                        ? null
                        : () => mainGameController.flipCard(gameCardModel),
              )),
        ));
  }
}
