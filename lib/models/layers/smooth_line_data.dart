// import 'package:fin_chart/models/i_candle.dart';
// import 'package:fin_chart/models/layers/layer.dart';
// import 'package:flutter/material.dart';

// class SmoothLineData extends Layer {
//   final List<ICandle> candles;

//   SmoothLineData({required this.candles});

//   @override
//   void onUpdateData({required List<ICandle> data}) {
//     candles.addAll(data.sublist(candles.isEmpty ? 0 : candles.length));
//   }

//   @override
//   void drawLayer({required Canvas canvas}) {
//     List<Offset> points = [];
//     for (int i = 0; i < candles.length; i++) {
//       points.add(toCanvas(Offset(i.toDouble(), candles[i].close)));
//     }

//     if (candles.length < 2) return;

//     final paint = Paint()
//       ..color = Colors.purple
//       ..strokeWidth = 2
//       ..strokeCap = StrokeCap.round
//       ..style = PaintingStyle.stroke;

//     final path = Path();
//     path.moveTo(points[0].dx, points[0].dy);

//     for (int i = 0; i < points.length - 1; i++) {
//       final xc = (points[i].dx + points[i + 1].dx) / 2;
//       final yc = (points[i].dy + points[i + 1].dy) / 2;

//       path.quadraticBezierTo(points[i].dx, points[i].dy, xc, yc);
//     }

//     path.lineTo(points.last.dx, points.last.dy);

//     canvas.drawPath(path, paint);
//   }
// }
