import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/models/settings/x_axis_settings.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';
import 'package:fin_chart/utils/constants.dart';
import 'package:flutter/material.dart';

class ChartPainter extends CustomPainter {
  final double leftPos;
  final double topPos;
  final double rightPos;
  final double bottomPos;
  final double yMinValue;
  final double yMaxValue;
  final double yMinPos;
  final double xStepWidth;
  final double xOffset;
  final YAxisSettings yAxisSettings;
  final XAxisSettings xAxisSettings;
  //final List<ICandle> candles;
  final List<PlotRegion> regions;

  ChartPainter(
      {super.repaint,
      required this.leftPos,
      required this.topPos,
      required this.rightPos,
      required this.bottomPos,
      required this.yMinValue,
      required this.yMaxValue,
      required this.yMinPos,
      required this.xStepWidth,
      required this.xOffset,
      required this.yAxisSettings,
      required this.xAxisSettings,
      //required this.candles,
      required this.regions});

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

    //drawYAxis(canvas);
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

    //plotCandles(canvas);
    for (PlotRegion region in regions) {
      region.drawLayers(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  drawXAxis(Canvas canvas) {
    for (int i = 0; i < 1000; i++) {
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
