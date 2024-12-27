import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension WidgetExtension on Widget {
  Widget get obx => Obx(() => this);
}
