import 'package:fin_chart/models/layers/layer.dart';
import 'package:flutter/material.dart';
import 'package:fin_chart/utils/calculations.dart';

enum Edges { left, top, right, bottom }

class RectArea extends Layer {
  late Offset topLeft;
  late Offset bottomRight;
  late Offset topRight;
  late Offset bottomLeft;
  bool isSelected = false;
  Color color = Colors.amber;
  late Offset startPoint;
  Edges? selectedEdge;

  RectArea.fromTool(
      {required this.topLeft,
      required this.bottomRight,
      required this.startPoint})
      : super.fromTool() {
    topRight = Offset(bottomRight.dx, topLeft.dy);
    bottomLeft = Offset(topLeft.dx, bottomRight.dy);
  }

  RectArea.fromJson({required Map<String, dynamic> data}) : super.fromJson() {
    topLeft = offsetFromJson(data['topLeft']);
    bottomRight = offsetFromJson(data['bottomRight']);
    color = colorFromJson(data['color']);
    // Initialize derived values
    topRight = Offset(bottomRight.dx, topLeft.dy);
    bottomLeft = Offset(topLeft.dx, bottomRight.dy);
    startPoint = Offset.zero; // Default value, will be set on interaction
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'topLeft': {'dx': topLeft.dx, 'dy': topLeft.dy},
      'bottomRight': {'dx': bottomRight.dx, 'dy': bottomRight.dy},
      'color': colorToJson(color)
    };
  }

  @override
  void drawLayer({required Canvas canvas}) {
    canvas.drawRect(
        Rect.fromPoints(toCanvas(topLeft), toCanvas(bottomRight)),
        Paint()
          ..color = color.withAlpha(100)
          ..style = PaintingStyle.fill);

    if (isSelected) {
      canvas.drawRect(
          Rect.fromLTRB(toX(topLeft.dx), toY(topLeft.dy), toX(bottomRight.dx),
              toY(bottomRight.dy)),
          Paint()
            ..color = color.withAlpha(255)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1);

      canvas.drawCircle(
          toCanvas(topLeft),
          5,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill
            ..strokeWidth = 5);

      canvas.drawCircle(
          toCanvas(topLeft),
          5,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3);

      canvas.drawCircle(
          toCanvas(topRight),
          5,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill
            ..strokeWidth = 5);

      canvas.drawCircle(
          toCanvas(topRight),
          5,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3);

      canvas.drawCircle(
          toCanvas(bottomRight),
          5,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill
            ..strokeWidth = 5);

      canvas.drawCircle(
          toCanvas(bottomRight),
          5,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3);

      canvas.drawCircle(
          toCanvas(bottomLeft),
          5,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill
            ..strokeWidth = 5);

      canvas.drawCircle(
          toCanvas(bottomLeft),
          5,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3);
    }
  }

  @override
  Layer? onTapDown({required TapDownDetails details}) {
    if (isPointNearRectFromDiagonalVertices(
        details.localPosition, toCanvas(topLeft), toCanvas(bottomRight))) {
      selectedEdge = null;
      if (isPointOnLine(
          details.localPosition, toCanvas(topLeft), toCanvas(bottomLeft))) {
        selectedEdge = Edges.left;
      } else if (isPointOnLine(
          details.localPosition, toCanvas(topLeft), toCanvas(topRight))) {
        selectedEdge = Edges.top;
      } else if (isPointOnLine(
          details.localPosition, toCanvas(topRight), toCanvas(bottomRight))) {
        selectedEdge = Edges.right;
      } else if (isPointOnLine(
          details.localPosition, toCanvas(bottomRight), toCanvas(bottomLeft))) {
        selectedEdge = Edges.bottom;
      }
      startPoint = details.localPosition;
      isSelected = true;
      return this;
    }
    isSelected = false;
    return super.onTapDown(details: details);
  }

  @override
  void onScaleUpdate({required ScaleUpdateDetails details}) {
    double xDeltaReal =
        toReal(details.localFocalPoint).dx - toReal(startPoint).dx;
    startPoint = details.localFocalPoint;

    switch (selectedEdge) {
      case null:
        topLeft = Offset(topLeft.dx + xDeltaReal,
            toYInverse(toY(topLeft.dy) + details.focalPointDelta.dy));
        topRight = Offset(topRight.dx + xDeltaReal,
            toYInverse(toY(topRight.dy) + details.focalPointDelta.dy));
        bottomLeft = Offset(bottomLeft.dx + xDeltaReal,
            toYInverse(toY(bottomLeft.dy) + details.focalPointDelta.dy));
        bottomRight = Offset(bottomRight.dx + xDeltaReal,
            toYInverse(toY(bottomRight.dy) + details.focalPointDelta.dy));
        break;
      case Edges.left:
        topLeft = Offset(topLeft.dx + xDeltaReal,
            toYInverse(toY(topLeft.dy) + details.focalPointDelta.dy));
        bottomLeft = Offset(bottomLeft.dx + xDeltaReal,
            toYInverse(toY(bottomLeft.dy) + details.focalPointDelta.dy));
        if (details.focalPointDelta.dy != 0) {
          topRight = Offset(topRight.dx,
              toYInverse(toY(topRight.dy) + details.focalPointDelta.dy));
          bottomRight = Offset(bottomRight.dx,
              toYInverse(toY(bottomRight.dy) + details.focalPointDelta.dy));
        }

        break;
      case Edges.top:
        topLeft = Offset(topLeft.dx + xDeltaReal,
            toYInverse(toY(topLeft.dy) + details.focalPointDelta.dy));
        topRight = Offset(topRight.dx + xDeltaReal,
            toYInverse(toY(topRight.dy) + details.focalPointDelta.dy));
        if (xDeltaReal != 0) {
          bottomLeft = Offset(
              bottomLeft.dx + xDeltaReal, toYInverse(toY(bottomLeft.dy)));
          bottomRight = Offset(
              bottomRight.dx + xDeltaReal, toYInverse(toY(bottomRight.dy)));
        }

        break;
      case Edges.right:
        topRight = Offset(topRight.dx + xDeltaReal,
            toYInverse(toY(topRight.dy) + details.focalPointDelta.dy));
        bottomRight = Offset(bottomRight.dx + xDeltaReal,
            toYInverse(toY(bottomRight.dy) + details.focalPointDelta.dy));
        if (details.focalPointDelta.dy != 0) {
          topLeft = Offset(topLeft.dx,
              toYInverse(toY(topLeft.dy) + details.focalPointDelta.dy));
          bottomLeft = Offset(bottomLeft.dx,
              toYInverse(toY(bottomLeft.dy) + details.focalPointDelta.dy));
        }
        break;
      case Edges.bottom:
        bottomLeft = Offset(bottomLeft.dx + xDeltaReal,
            toYInverse(toY(bottomLeft.dy) + details.focalPointDelta.dy));
        bottomRight = Offset(bottomRight.dx + xDeltaReal,
            toYInverse(toY(bottomRight.dy) + details.focalPointDelta.dy));
        if (xDeltaReal != 0) {
          topLeft =
              Offset(topLeft.dx + xDeltaReal, toYInverse(toY(topLeft.dy)));
          topRight =
              Offset(topRight.dx + xDeltaReal, toYInverse(toY(topRight.dy)));
        }

        break;
    }

    super.onScaleUpdate(details: details);
  }
}
