import 'package:flutter/material.dart';

class CommonWidget {
  static Color getBackgoundColor(String type) {
    Color bgColor = Colors.white;

    if (type == "grass") {
      bgColor = const Color(0xFF48d0b0);
    } else if (type == "fire") {
      bgColor = const Color(0xFFfb6c6c);
    } else if (type == "water") {
      bgColor = Colors.blue;
    } else if (type == "bug") {
      bgColor = const Color(0xFFffce4b);
    } else {
      bgColor = Colors.purpleAccent;
    }

    return bgColor;
  }
}
