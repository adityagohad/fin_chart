import 'package:fin_chart/models/enums/candle_state.dart';
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/utils/constants.dart';
import 'package:flutter/material.dart';

class CandleData extends Layer {
  final List<ICandle> candles;

  CandleData({required this.candles});

  @override
  void drawLayer({required Canvas canvas}) {
    for (int i = 0; i < candles.length; i++) {
      ICandle candle = candles[i];
      Color candleColor;
      if (candle.state == CandleState.selected) {
        candleColor = Colors.orange;
      } else if (candle.state == CandleState.highlighted) {
        candleColor = Colors.purple;
      } else if (candle.open < candle.close) {
        candleColor = Colors.green;
      } else {
        candleColor = Colors.red;
      }

      Paint paint = Paint()
        ..strokeWidth = 2
        ..style = PaintingStyle.fill
        ..color = candleColor;

      canvas.drawLine(Offset(toX(i.toDouble()), toY(candle.high)),
          Offset(toX(i.toDouble()), toY(candle.low)), paint);

      canvas.drawRect(
          Rect.fromLTRB(toX(i.toDouble()) - candleWidth / 2, toY(candle.open),
              toX(i.toDouble()) + candleWidth / 2, toY(candle.close)),
          paint);

      // if (toX(i) >= leftPos && toX(i) <= rightPos) {
      //   canvas.drawLine(Offset(toX(i), toY(candle.high)),
      //       Offset(toX(i), toY(candle.low)), paint);

      //   canvas.drawRect(
      //       Rect.fromLTRB(toX(i) - candleWidth / 2, toY(candle.open),
      //           toX(i) + candleWidth / 2, toY(candle.close)),
      //       paint);
      // }
      // if (toX(i) > rightPos) {
      //   break;
      // }
    }
  }
}
