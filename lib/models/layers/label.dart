import 'package:fin_chart/models/layers/layer.dart';
import 'package:flutter/material.dart';

class Label extends Layer {
  Offset pos;
  String label;
  TextStyle textStyle;
  Label({required this.pos, required this.label, required this.textStyle});
  @override
  void drawLayer({required Canvas canvas}) {
    final TextPainter text = TextPainter(
      text: TextSpan(
        text: label,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    text.paint(canvas, toCanvas(pos));
  }
}
