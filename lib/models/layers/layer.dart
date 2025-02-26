import 'package:flutter/material.dart';

abstract class Layer {
  Layer onTapDown(TapDownDetails details);
  void draw(Canvas canvas);
  void drawAxisIndicators(Canvas canvas);
}
