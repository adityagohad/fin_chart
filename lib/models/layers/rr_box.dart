import 'package:fin_chart/models/layers/layer.dart';
import 'package:flutter/material.dart';

class RrBox extends Layer {
  double target;
  double stoploss;
  double startPrice;
  double startPointTime;
  double endPointTime;

  RrBox(
      {required this.target,
      required this.stoploss,
      required this.startPrice,
      required this.startPointTime,
      required this.endPointTime});

  @override
  void drawLayer({required Canvas canvas}) {
    canvas.drawRect(
        Rect.fromPoints(toCanvas(Offset(startPointTime, target)),
            toCanvas(Offset(endPointTime, startPrice))),
        Paint()
          ..color = Colors.green.withAlpha(100)
          ..style = PaintingStyle.fill);

    canvas.drawRect(
        Rect.fromPoints(toCanvas(Offset(startPointTime, stoploss)),
            toCanvas(Offset(endPointTime, startPrice))),
        Paint()
          ..color = Colors.red.withAlpha(100)
          ..style = PaintingStyle.fill);
  }
}
