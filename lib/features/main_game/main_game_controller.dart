import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memory_game_getx/core/model/game_card_model.dart';

class MainGameController extends GetxController {
  var gameState = MainGameState.idle.obs;
  var turnState = TurnState.ali.obs;

  var aliScore = 0.0.obs;
  var sebnemScore = 0.0.obs;

  final gameCardList = <GameCardModel>[].obs;

  int gameCardSize = 6;

  @override
  void onInit() {
    super.onInit();
    _generateGameCardList();
    _generateRandomTurn();
  }

  _generateRandomTurn() {
    turnState.value = TurnState.values[Random().nextInt(TurnState.values.length)];
  }

  resetGame() {
    gameCardList.clear();
    aliScore.value = 0;
    sebnemScore.value = 0;
    gameState.value = MainGameState.idle;
    _generateGameCardList();
    _generateRandomTurn();
  }

  bool isGameOver() => gameCardList.every((element) => element.isMatched.value);

  String showWinner() {
    if (aliScore.value > sebnemScore.value) {
      return 'Ali wins';
    } else if (aliScore.value < sebnemScore.value) {
      return 'Sebnem wins';
    } else {
      return 'Draw';
    }
  }

  Color backGroundColorForTurnState() {
    switch (turnState.value) {
      case TurnState.ali:
        return Colors.blue.shade100;
      case TurnState.sebnem:
        return Colors.red.shade100;
    }
  }

  flipCard(GameCardModel gameCardModel) async {
    switch (gameState.value) {
      case MainGameState.idle:
        _flipCard(gameCardModel);
        gameState.value = MainGameState.firstCardFlipped;
        break;
      case MainGameState.firstCardFlipped:
        _flipCard(gameCardModel);
        if (gameCardList.where((p0) => !p0.isMatched.value).where((element) => element.isFlipped.value).where((element) => element.color == gameCardModel.color).length == 2) {
          gameCardList.where((p0) => !p0.isMatched.value).where((element) => element.isFlipped.value).where((element) => element.color == gameCardModel.color).forEach((element) {
            turnState.value == TurnState.ali ? aliScore.value += 0.5 : sebnemScore.value += 0.5;
            element.isMatched.value = true;
            gameState.value = MainGameState.idle;
          });
        } else {
          gameState.value = MainGameState.secondCardFlipped;
          Future.delayed(const Duration(milliseconds: 500), () => _flipBackAllCardsExceptMatched());
        }
        break;
      case MainGameState.secondCardFlipped:
        break;
    }
  }

  _flipBackAllCardsExceptMatched() {
    gameCardList.where((element) => !element.isMatched.value).forEach((element) {
      element.isFlipped.value = false;
    });
    gameState.value = MainGameState.idle;
    turnState.value = turnState.value == TurnState.ali ? TurnState.sebnem : TurnState.ali;
  }

  void _flipCard(GameCardModel gameCardModel) {
    gameCardList[gameCardModel.id].isFlipped.value = true;
  }

  _generateGameCardList() {
    List<Color> colors = List.generate(gameCardSize, (index) => randomColor());
    colors.addAll([...colors]);

    List<GameCardModel> initialList = List.generate(
      colors.length,
      (index) => GameCardModel(
        id: index,
        color: colors[index],
        isFlipped: false.obs,
        isMatched: false.obs,
      ),
    );

    gameCardList.addAll(initialList);
  }
}

Color randomColor() {
  return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}

enum MainGameState {
  idle,
  firstCardFlipped,
  secondCardFlipped,
}

enum TurnState {
  ali,
  sebnem,
}

extension MainGameStateExtension on MainGameState {
  MainGameState get next {
    switch (this) {
      case MainGameState.idle:
        return MainGameState.firstCardFlipped;
      case MainGameState.firstCardFlipped:
        return MainGameState.secondCardFlipped;
      case MainGameState.secondCardFlipped:
        return MainGameState.firstCardFlipped;
      default:
        return MainGameState.idle;
    }
  }
}
