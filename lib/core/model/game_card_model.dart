import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameCardModel {
  final int id;
  final Color color;
  RxBool isFlipped;
  RxBool isMatched;
  GameCardModel({
    required this.id,
    required this.color,
    required this.isFlipped,
    required this.isMatched,
  });
}
