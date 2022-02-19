import 'dart:ui';
import 'package:flutter/material.dart';

class CommonWidget {
  static Color getBackgoundColor(String type) {
    Color bgColor = Colors.white;

    if (type == "grass") {
      bgColor = Colors.lightGreen;
    } else if (type == "fire") {
      bgColor = Colors.orange;
    } else if (type == "water") {
      bgColor = Colors.blue;
    } else if (type == "bug") {
      bgColor = Colors.cyan;
    } else {
      bgColor = Colors.purpleAccent;
    }

    return bgColor;
  }
}