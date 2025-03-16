import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Arrow extends Layer {
  late Offset from;
  late Offset to;
  Color color = Colors.black;
  double strokeWidth = 2;
  double arrowheadSize = 15;
  bool isArrowheadAtTo = true; // Direction flag (true = arrow at 'to' end)

  bool isSelected = false;
  late Offset startPoint;
  Offset? tempFrom;
  Offset? tempTo;

  Arrow.fromTool(
      {required this.from, required this.to, required this.startPoint})
      : super.fromTool() {
    isSelected = true;
    tempTo = to;
  }

  Arrow.fromJson({required Map<String, dynamic> data}) : super.fromJson() {
    from = offsetFromJson(data['from']);
    to = offsetFromJson(data['to']);
    strokeWidth = data['strokeWidth'] ?? 2;
    arrowheadSize = data['arrowheadSize'] ?? 10;
    color = colorFromJson(data['color']);
    isArrowheadAtTo = data['isArrowheadAtTo'] ?? true;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'from': {'dx': from.dx, 'dy': from.dy},
      'to': {'dx': to.dx, 'dy': to.dy},
      'strokeWidth': strokeWidth,
      'arrowheadSize': arrowheadSize,
      'color': colorToJson(color),
      'isArrowheadAtTo': isArrowheadAtTo
    };
  }

  @override
  void drawLayer({required Canvas canvas}) {
    Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..color = color;

    // Draw the main line
    canvas.drawLine(Offset(toX(from.dx), toY(from.dy)),
        Offset(toX(to.dx), toY(to.dy)), paint);

    // Draw arrowhead
    _drawArrowhead(canvas, paint);

    if (isSelected) {
      // Draw circles at endpoints
      canvas.drawCircle(
          toCanvas(from),
          arrowheadSize,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill
            ..strokeWidth = arrowheadSize);
      canvas.drawCircle(
          toCanvas(from),
          arrowheadSize,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth);

      canvas.drawCircle(
          toCanvas(to),
          arrowheadSize,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill
            ..strokeWidth = arrowheadSize);
      canvas.drawCircle(
          toCanvas(to),
          arrowheadSize,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth);
    }
  }

  void _drawArrowhead(Canvas canvas, Paint linePaint) {
    // Determine which points to use based on direction
    Offset start = isArrowheadAtTo ? from : to;
    Offset end = isArrowheadAtTo ? to : from;

    // Convert to canvas coordinates
    Offset startPoint = Offset(toX(start.dx), toY(start.dy));
    Offset endPoint = Offset(toX(end.dx), toY(end.dy));

    // Calculate angle of the line
    double angle = math.atan2(
      endPoint.dy - startPoint.dy,
      endPoint.dx - startPoint.dx,
    );

    // Create arrowhead path
    Path arrowPath = Path();

    // Move to tip of arrow
    arrowPath.moveTo(endPoint.dx, endPoint.dy);

    // Draw one side of arrowhead
    arrowPath.lineTo(
      endPoint.dx - arrowheadSize * math.cos(angle - math.pi / 6),
      endPoint.dy - arrowheadSize * math.sin(angle - math.pi / 6),
    );

    // Draw the other side of arrowhead
    arrowPath.lineTo(
      endPoint.dx - arrowheadSize * math.cos(angle + math.pi / 6),
      endPoint.dy - arrowheadSize * math.sin(angle + math.pi / 6),
    );

    // Close the path to create the filled triangle
    arrowPath.close();

    // Draw the arrowhead
    canvas.drawPath(
      arrowPath,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  Layer? onTapDown({required TapDownDetails details}) {
    if (isPointInCircularRegion(
        details.localPosition, toCanvas(from), arrowheadSize * 2)) {
      isSelected = true;
      startPoint = details.localPosition;
      tempFrom = from;
      tempTo = null;
      return this;
    } else if (isPointInCircularRegion(
        details.localPosition, toCanvas(to), arrowheadSize * 2)) {
      isSelected = true;
      startPoint = details.localPosition;
      tempTo = to;
      tempFrom = null;
      return this;
    } else if (isPointOnLine(details.localPosition,
        Offset(toX(from.dx), toY(from.dy)), Offset(toX(to.dx), toY(to.dy)),
        tolerance: arrowheadSize * 2)) {
      isSelected = true;
      startPoint = details.localPosition;
      tempFrom = from;
      tempTo = to;
      return this;
    }
    isSelected = false;
    tempFrom = null;
    tempTo = null;
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

  // Method to toggle the arrow direction
  void toggleDirection() {
    isArrowheadAtTo = !isArrowheadAtTo;
  }
}
