import 'package:fin_chart/models/layers/layer.dart';
import 'package:flutter/material.dart';

class TrendLine extends Layer {
  Offset from;
  Offset to;
  bool isSelected = false;
  Color color = Colors.black;
  late Offset startPoint;
  Offset? tempFrom;
  Offset? tempTo;

  TrendLine({required this.from, required this.to});

  TrendLine.fromTool(
      {required this.from,
      required this.to,
      required this.startPoint,
      required this.tempTo,
      this.isSelected = true});

  @override
  void drawLayer({required Canvas canvas}) {
    Paint paint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..color = isSelected ? Colors.blue : color;

    canvas.drawLine(Offset(toX(from.dx), toY(from.dy)),
        Offset(toX(to.dx), toY(to.dy)), paint);

    if (isSelected) {
      canvas.drawCircle(
          toCanvas(from),
          5,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill
            ..strokeWidth = 5);
      canvas.drawCircle(
          toCanvas(from),
          5,
          Paint()
            ..color = Colors.blue
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3);

      canvas.drawCircle(
          toCanvas(to),
          5,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill
            ..strokeWidth = 5);
      canvas.drawCircle(
          toCanvas(to),
          5,
          Paint()
            ..color = Colors.blue
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3);
    }
  }

  @override
  Layer? onTapDown({required TapDownDetails details}) {
    if (isPointInCircularRegion(details.localPosition, toCanvas(from), 10)) {
      isSelected = true;
      startPoint = details.localPosition;
      tempFrom = from;
      tempTo = null;
      return this;
    } else if (isPointInCircularRegion(
        details.localPosition, toCanvas(to), 10)) {
      isSelected = true;
      startPoint = details.localPosition;
      tempTo = to;
      tempFrom = null;
      return this;
    } else if (isPointOnLine(details.localPosition,
        Offset(toX(from.dx), toY(from.dy)), Offset(toX(to.dx), toY(to.dy)))) {
      isSelected = true;
      startPoint = details.localPosition;
      tempFrom = from;
      tempTo = to;
      return this;
    }
    isSelected = false;
    tempFrom = null;
    tempFrom = null;
    return super.onTapDown(details: details);
  }

  @override
  void onScaleUpdate({required ScaleUpdateDetails details}) {
    Offset displacement =
        displacementOffset(startPoint, details.localFocalPoint);

    if (tempFrom != null) {
      from = Offset(
          tempFrom!.dx + displacement.dx, tempFrom!.dy + displacement.dy);
    }

    if (tempTo != null) {
      to = Offset(tempTo!.dx + displacement.dx, tempTo!.dy + displacement.dy);
    }
  }
}
