import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/model/game_card_model.dart';

class GameCardController extends GetxController {
  Color isFlippedOrMatch(GameCardModel gameCardModel) {
    return gameCardModel.isMatched.value
        ? gameCardModel.color
        : gameCardModel.isFlipped.value
            ? gameCardModel.color
            : Colors.white;
  }
}
