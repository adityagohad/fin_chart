import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/models/settings/x_axis_settings.dart';
import 'package:fin_chart/utils/constants.dart';
import 'package:flutter/material.dart';

class ChartPainter extends CustomPainter {
  final double leftPos;
  final double topPos;
  final double rightPos;
  final double bottomPos;
  final double xStepWidth;
  final double xOffset;
  final XAxisSettings xAxisSettings;
  final List<PlotRegion> regions;
  final int dataLength;

  ChartPainter(
      {super.repaint,
      required this.leftPos,
      required this.topPos,
      required this.rightPos,
      required this.bottomPos,
      required this.xStepWidth,
      required this.xOffset,
      required this.xAxisSettings,
      required this.regions,
      required this.dataLength});

  @override
  void paint(Canvas canvas, Size size) {
    final outerBoundries = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(
        outerBoundries,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = Colors.transparent);
    canvas.clipRect(outerBoundries);

    drawXAxis(canvas);

    for (PlotRegion region in regions) {
      region.drawYAxis(canvas);
    }

    for (PlotRegion region in regions) {
      region.drawAxisValue(canvas);
    }

    final innerBoundries = Rect.fromLTRB(leftPos, topPos, rightPos, bottomPos);

    canvas.drawRect(
        innerBoundries,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = Colors.transparent);

    canvas.clipRect(innerBoundries);

    for (PlotRegion region in regions) {
      if (region.isSelected) {
        canvas.drawRect(
            Rect.fromLTRB(region.leftPos, region.topPos, region.rightPos,
                region.bottomPos),
            Paint()
              ..color = Colors.amber.withAlpha(100)
              ..style = PaintingStyle.fill);
      }
      region.drawBaseLayer(canvas);
      region.drawLayers(canvas);
      canvas.drawLine(
          Offset(leftPos, region.bottomPos),
          Offset(rightPos, region.bottomPos),
          Paint()
            ..color = Colors.grey
            ..strokeWidth = 3);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  drawXAxis(Canvas canvas) {
    for (int i = 0; i < dataLength; i++) {
      if (leftPos + xOffset + xStepWidth / 2 + i * xStepWidth > leftPos &&
          leftPos + xOffset + xStepWidth / 2 + i * xStepWidth < rightPos) {
        final TextPainter text = TextPainter(
          text: TextSpan(
            text: i.toStringAsFixed(0),
            style: xAxisSettings.axisTextStyle,
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        if (xAxisSettings.xAxisPos == XAxisPos.bottom) {
          canvas.drawCircle(
              Offset(leftPos + xOffset + xStepWidth / 2 + i * xStepWidth,
                  bottomPos),
              1,
              Paint()..color = xAxisSettings.axisColor);

          // canvas.drawLine(
          //     Offset(
          //         leftPos + xOffset + xStepWidth / 2 + i * xStepWidth, topPos),
          //     (Offset(leftPos + xOffset + xStepWidth / 2 + i * xStepWidth,
          //         bottomPos)),
          //     Paint());

          text.paint(
              canvas,
              Offset(
                  leftPos +
                      xOffset +
                      xStepWidth / 2 +
                      i * xStepWidth -
                      text.width / 2,
                  bottomPos + xLabelPadding / 2));
        }

        if (xAxisSettings.xAxisPos == XAxisPos.top) {
          canvas.drawCircle(
              Offset(
                  leftPos + xOffset + xStepWidth / 2 + i * xStepWidth, topPos),
              1,
              Paint()..color = xAxisSettings.axisColor);

          text.paint(
              canvas,
              Offset(
                  leftPos +
                      xOffset +
                      xStepWidth / 2 +
                      i * xStepWidth -
                      text.width / 2,
                  topPos - (text.height + xLabelPadding / 2)));
        }
      }
    }

    if (xAxisSettings.xAxisPos == XAxisPos.bottom) {
      canvas.drawLine(
          Offset(leftPos, bottomPos),
          Offset(rightPos, bottomPos),
          Paint()
            ..color = xAxisSettings.axisColor
            ..strokeWidth = xAxisSettings.strokeWidth);
    }

    if (xAxisSettings.xAxisPos == XAxisPos.top) {
      canvas.drawLine(
          Offset(leftPos, topPos),
          Offset(rightPos, topPos),
          Paint()
            ..color = xAxisSettings.axisColor
            ..strokeWidth = xAxisSettings.strokeWidth);
    }
  }
}
