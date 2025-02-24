import 'package:fin_chart/chart_painter.dart';
import 'package:fin_chart/fin_chart.dart';
import 'package:fin_chart/models/enums/data_fit_type.dart';
import 'package:fin_chart/models/settings/x_axis_settings.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:fin_chart/utils/constants.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  final EdgeInsets? padding;
  final DataFit dataFit;
  final List<ICandle> candles;
  final YAxisSettings? yAxisSettings;
  final XAxisSettings? xAxisSettings;
  const Chart(
      {super.key,
      this.padding = const EdgeInsets.all(8),
      this.dataFit = DataFit.adaptiveWidth,
      required this.candles,
      this.yAxisSettings = const YAxisSettings(),
      this.xAxisSettings = const XAxisSettings()});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late double leftPos;
  late double topPos;
  late double rightPos;
  late double bottomPos;

  double xOffset = 0;

  double horizontalScale = 1;
  double previousHorizontalScale = 1.0;
  Offset? lastFocalPoint;

  double yLabelWidth = 62;
  double xLabelHeight = 21;

  double yMinValue = 0;
  double yMaxValue = 100;
  double xStepWidth = candleWidth * 2;

  setCanvasCorners(BoxConstraints constraints) {
    if (widget.yAxisSettings!.yAxisPos == YAxisPos.left) {
      leftPos = yLabelWidth + yLabelPadding;
      rightPos = constraints.maxWidth - yLabelPadding;
    }

    if (widget.xAxisSettings!.xAxisPos == XAxisPos.top) {
      topPos = xLabelHeight + xLabelPadding;
      bottomPos = constraints.maxHeight - xLabelPadding;
    }

    if (widget.yAxisSettings!.yAxisPos == YAxisPos.right) {
      leftPos = yLabelPadding;
      rightPos = constraints.maxWidth - (yLabelWidth + yLabelPadding);
    }

    if (widget.xAxisSettings!.xAxisPos == XAxisPos.bottom) {
      topPos = xLabelPadding;
      bottomPos = constraints.maxHeight - (xLabelHeight + xLabelPadding);
    }
  }

  setXYValues() {
    (double, double) range = findMinMaxWithPercentage(widget.candles);
    yMinValue = range.$1;
    yMaxValue = range.$2;
    Size yLabelSize = getLargetRnderBoxSizeForList(
        generateNiceAxisValues(yMinValue, yMaxValue)
            .map((v) => v.toString())
            .toList(),
        widget.yAxisSettings!.axisTextStyle);
    yLabelWidth = yLabelSize.width;
  }

  double getMaxLeftOffset() {
    if (widget.candles.isEmpty) return 0;

    double lastCandlePosition =
        xStepWidth / 2 + (widget.candles.length - 1) * xStepWidth;

    if (lastCandlePosition < (rightPos - leftPos) / 2) {
      return 0;
    } else {
      return -lastCandlePosition + (rightPos - leftPos) / 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: widget.padding,
        child: LayoutBuilder(builder: (context, constraints) {
          setXYValues();
          setCanvasCorners(constraints);
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: GestureDetector(
              onDoubleTap: _onDoubleTap,
              onScaleStart: _onScaleStart,
              onScaleEnd: _onScaleEnd,
              onScaleUpdate: (details) => _onScaleUpdate(details, constraints),
              child: CustomPaint(
                painter: ChartPainter(
                    candles: widget.candles,
                    xAxisSettings: widget.xAxisSettings!,
                    yAxisSettings: widget.yAxisSettings!,
                    xOffset: xOffset,
                    xStepWidth: xStepWidth,
                    yMinPos: (constraints.maxHeight -
                            (xLabelHeight + xLabelPadding)) *
                        1,
                    yMinValue: yMinValue,
                    yMaxValue: yMaxValue,
                    leftPos: leftPos,
                    topPos: topPos,
                    rightPos: rightPos,
                    bottomPos: bottomPos),
                size: Size(constraints.maxWidth, constraints.maxHeight),
              ),
            ),
          );
        }));
  }

  _onDoubleTap() {
    setState(() {
      horizontalScale = 1;
      previousHorizontalScale = 1;
      xStepWidth = candleWidth * 2;
      xOffset = 0;
    });
  }

  _onScaleStart(ScaleStartDetails details) {
    setState(() {
      if (details.pointerCount == 2) {
        previousHorizontalScale = horizontalScale;
        lastFocalPoint = details.focalPoint;
      }
    });
  }

  _onScaleEnd(ScaleEndDetails details) {
    setState(() {
      lastFocalPoint = null;
    });
  }

  _onScaleUpdate(ScaleUpdateDetails details, BoxConstraints constraints) {
    setState(() {
      if (details.pointerCount == 1) {
        xOffset =
            (xOffset + details.focalPointDelta.dx).clamp(getMaxLeftOffset(), 0);
      }
      if (details.pointerCount == 2) {
        final newScale =
            (previousHorizontalScale * details.scale).clamp(0.5, 5.0);
        if (lastFocalPoint != null) {
          final focalPointRatio = lastFocalPoint!.dx / constraints.maxWidth;
          final scaleDiff = newScale - horizontalScale;
          final offsetAdjustment = scaleDiff *
              (candleWidth * 2) *
              widget.candles.length *
              focalPointRatio;
          xOffset = (xOffset - offsetAdjustment).clamp(getMaxLeftOffset(), 0);
        }

        horizontalScale = newScale;
        lastFocalPoint = details.localFocalPoint;
        xStepWidth = (candleWidth * 2) * horizontalScale;
      }
    });
  }
}
