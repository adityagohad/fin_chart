import 'package:fin_chart/chart_painter.dart';
import 'package:fin_chart/models/enums/data_fit_type.dart';
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/layers/candle_data.dart';
import 'package:fin_chart/models/layers/chart_pointer.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/models/layers/rect_area.dart';
import 'package:fin_chart/models/layers/trend_line.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/models/settings/x_axis_settings.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:fin_chart/utils/constants.dart';
import 'package:flutter/material.dart';

import 'models/settings/y_axis_settings.dart';

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

class _ChartState extends State<Chart> with SingleTickerProviderStateMixin {
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
  double yMaxValue = 1;
  double xStepWidth = candleWidth * 2;

  late AnimationController _swipeAnimationController;
  double _swipeVelocity = 0;
  bool _isAnimating = false;

  List<PlotRegion> regions = [];
  Layer? selectedLayer;

  @override
  void initState() {
    super.initState();

    regions.add(PlotRegion(
        type: PlotRegionType.main,
        yAxisSettings: widget.yAxisSettings!,
        layers: [
          CandleData(candles: widget.candles),
          ChartPointer(pointOffset: const Offset(2, 4400)),
          TrendLine(from: const Offset(2, 3400), to: const Offset(8, 4400)),
          RectArea(
              topLeft: const Offset(15, 3600),
              bottomRight: const Offset(29, 4200))
        ]));
    _swipeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(_handleSwipeAnimation);
  }

  @override
  void dispose() {
    _swipeAnimationController.dispose();
    super.dispose();
  }

  recalculate(BoxConstraints constraints) {
    (double, double) range = findMinMaxWithPercentage(widget.candles);
    yMinValue = range.$1;
    yMaxValue = range.$2;

    List<double> yValues = generateNiceAxisValues(yMinValue, yMaxValue);

    yMinValue = yValues.first;
    yMaxValue = yValues.last;

    Size yLabelSize = getLargetRnderBoxSizeForList(
        yValues.map((v) => v.toString()).toList(),
        widget.yAxisSettings!.axisTextStyle);

    yLabelWidth = yLabelSize.width;

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

    for (int i = 0; i < regions.length; i++) {
      regions[i].updateRegionProp(
          leftPos: leftPos,
          topPos: topPos,
          rightPos: rightPos,
          bottomPos: bottomPos,
          xStepWidth: xStepWidth,
          xOffset: xOffset,
          yMinValue: yMinValue,
          yMaxValue: yMaxValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: widget.padding,
        child: LayoutBuilder(builder: (context, constraints) {
          recalculate(constraints);
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: GestureDetector(
              onTapDown: _onTapDown,
              onDoubleTap: _onDoubleTap,
              onScaleStart: _onScaleStart,
              onScaleEnd: _onScaleEnd,
              onScaleUpdate: (details) => _onScaleUpdate(details, constraints),
              child: CustomPaint(
                painter: ChartPainter(
                    regions: regions,
                    //candles: widget.candles,
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

  void _handleSwipeAnimation() {
    if (!_isAnimating) return;

    setState(() {
      final double progress = _swipeAnimationController.value;
      final double dampedVelocity =
          _swipeVelocity * (1 - progress) * (1 - progress); // Add extra damping
      xOffset = (xOffset + dampedVelocity).clamp(getMaxLeftOffset(), 0);

      if (progress >= 1.0) {
        _isAnimating = false;
        _swipeVelocity = 0;
      }
    });
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

  void _handleSwipeEnd(ScaleEndDetails details) {
    // Calculate velocity and start animation
    _swipeVelocity = details.velocity.pixelsPerSecond.dx *
        0.1; // Reduce velocity sensitivity
    if (_swipeVelocity.abs() > 100) {
      // Increase threshold for animation
      _isAnimating = true;
      _swipeAnimationController.forward(from: 0);
    }
  }

  _onDoubleTap() {
    setState(() {
      horizontalScale = 1;
      previousHorizontalScale = 1;
      xStepWidth = candleWidth * 2;
      xOffset = 0;
      _isAnimating = false;
      _swipeVelocity = 0;
    });
  }

  _onTapDown(TapDownDetails details) {
    selectedLayer = null;
    for (PlotRegion region in regions) {
      for (Layer layer in region.layers) {
        setState(() {
          if (selectedLayer == null) {
            selectedLayer = layer.onTapDown(details: details);
          } else {
            layer.onTapDown(details: details);
          }
        });
      }
    }
    //print(selectedLayer);
  }

  _onScaleStart(ScaleStartDetails details) {
    setState(() {
      _isAnimating = false;
      if (details.pointerCount == 2) {
        previousHorizontalScale = horizontalScale;
        lastFocalPoint = details.focalPoint;
      }
    });
  }

  _onScaleEnd(ScaleEndDetails details) {
    setState(() {
      lastFocalPoint = null;
      _handleSwipeEnd(details);
    });
  }

  _onScaleUpdate(ScaleUpdateDetails details, BoxConstraints constraints) {
    setState(() {
      if (details.pointerCount == 1) {
        if (selectedLayer == null) {
          setState(() {
            _isAnimating = false; // Stop any ongoing animation
            xOffset = (xOffset + details.focalPointDelta.dx)
                .clamp(getMaxLeftOffset(), 0);
          });
        } else {
          selectedLayer?.onScaleUpdate(details: details);
        }
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
