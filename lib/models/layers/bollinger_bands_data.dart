// import 'dart:math' as math;
// import 'package:fin_chart/models/i_candle.dart';
// import 'package:fin_chart/models/layers/layer.dart';
// import 'package:fin_chart/utils/calculations.dart';
// import 'package:flutter/material.dart';

// class BollingerBandsData extends Layer {
//   List<ICandle> candles;
//   final int period;
//   final double multiplier;
//   final Color upperBandColor;
//   final Color middleBandColor;
//   final Color lowerBandColor;
//   final double opacity;

//   final List<double> smaValues = [];
//   final List<double> upperBandValues = [];
//   final List<double> lowerBandValues = [];

//   BollingerBandsData({
//     required this.candles,
//     this.period = 20,
//     this.multiplier = 2.0,
//     this.upperBandColor = Colors.red,
//     this.middleBandColor = Colors.blue,
//     this.lowerBandColor = Colors.green,
//     this.opacity = 0.2,
//   }) : super.fromTool(id: generateV4(), ) {
//     _calculateBollingerBands();
//   }

//   @override
//   void onUpdateData({required List<ICandle> data}) {
//     if (candles.isEmpty) {
//       candles.addAll(data);
//     } else {
//       int existingCount = candles.length;
//       if (data.length > existingCount) {
//         candles.addAll(data.sublist(existingCount));
//       }
//     }

//     _calculateBollingerBands();
//   }

//   void _calculateBollingerBands() {
//     smaValues.clear();
//     upperBandValues.clear();
//     lowerBandValues.clear();

//     if (candles.length < period) {
//       return;
//     }

//     // Calculate SMA and standard deviation for each window
//     for (int i = 0; i < candles.length; i++) {
//       if (i < period - 1) {
//         smaValues.add(0);
//         upperBandValues.add(0);
//         lowerBandValues.add(0);
//       } else {
//         // Calculate SMA for this window
//         double sum = 0;
//         for (int j = i - (period - 1); j <= i; j++) {
//           sum += candles[j].close;
//         }
//         double sma = sum / period;
//         smaValues.add(sma);

//         // Calculate standard deviation
//         double variance = 0;
//         for (int j = i - (period - 1); j <= i; j++) {
//           variance += math.pow(candles[j].close - sma, 2);
//         }
//         double stdDev = math.sqrt(variance / period);

//         // Calculate upper and lower bands
//         upperBandValues.add(sma + (multiplier * stdDev));
//         lowerBandValues.add(sma - (multiplier * stdDev));
//       }
//     }
//   }

//   @override
//   void drawLayer({required Canvas canvas}) {
//     if (candles.isEmpty || smaValues.isEmpty) {
//       return;
//     }

//     final startIndex = period - 1;
//     if (startIndex >= smaValues.length) {
//       return;
//     }

//     // Draw the middle band (SMA)
//     _drawLine(canvas, smaValues, middleBandColor);

//     // Draw upper band
//     _drawLine(canvas, upperBandValues, upperBandColor);

//     // Draw lower band
//     _drawLine(canvas, lowerBandValues, lowerBandColor);

//     // Draw filled area between bands for visualization
//     _drawFilledArea(canvas, upperBandValues, lowerBandValues);
//   }

//   void _drawLine(Canvas canvas, List<double> values, Color color) {
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = 1.5
//       ..style = PaintingStyle.stroke;

//     final path = Path();
//     bool pathStarted = false;

//     for (int i = period - 1; i < values.length; i++) {
//       if (values[i] == 0) continue;

//       final x = toX(i.toDouble());
//       final y = toY(values[i]);

//       if (!pathStarted) {
//         path.moveTo(x, y);
//         pathStarted = true;
//       } else {
//         path.lineTo(x, y);
//       }
//     }

//     if (pathStarted) {
//       canvas.drawPath(path, paint);
//     }
//   }

//   void _drawFilledArea(Canvas canvas, List<double> upper, List<double> lower) {
//     final fillPaint = Paint()
//       ..color = middleBandColor.withOpacity(opacity)
//       ..style = PaintingStyle.fill;

//     final path = Path();
//     bool pathStarted = false;

//     // First draw the upper band
//     for (int i = period - 1; i < upper.length; i++) {
//       if (upper[i] == 0) continue;

//       final x = toX(i.toDouble());
//       final y = toY(upper[i]);

//       if (!pathStarted) {
//         path.moveTo(x, y);
//         pathStarted = true;
//       } else {
//         path.lineTo(x, y);
//       }
//     }

//     // Then draw the lower band in reverse
//     for (int i = lower.length - 1; i >= period - 1; i--) {
//       if (lower[i] == 0) continue;

//       final x = toX(i.toDouble());
//       final y = toY(lower[i]);

//       path.lineTo(x, y);
//     }

//     if (pathStarted) {
//       path.close();
//       canvas.drawPath(path, fillPaint);
//     }
//   }
// }
