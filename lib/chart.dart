import 'package:fin_chart/chart_painter.dart';
import 'package:fin_chart/models/enums/data_fit_type.dart';
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/layers/candle_data.dart';
import 'package:fin_chart/models/layers/chart_pointer.dart';
import 'package:fin_chart/models/layers/horizontal_line.dart';
import 'package:fin_chart/models/layers/label.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/models/layers/line_data.dart';
import 'package:fin_chart/models/layers/rect_area.dart';
import 'package:fin_chart/models/layers/smooth_line_data.dart';
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
  final List<PlotRegion> regions;
  final YAxisSettings? yAxisSettings;
  final XAxisSettings? xAxisSettings;
  const Chart(
      {super.key,
      this.padding = const EdgeInsets.all(8),
      this.dataFit = DataFit.adaptiveWidth,
      required this.candles,
      this.yAxisSettings = const YAxisSettings(),
      this.xAxisSettings = const XAxisSettings(),
      required this.regions});

  @override
  State<Chart> createState() => ChartState();
}

class ChartState extends State<Chart> with SingleTickerProviderStateMixin {
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
  List<ICandle> currentData = [];

  @override
  void initState() {
    super.initState();
    regions.addAll(widget.regions);
    //addLater();
    // regions.add(PlotRegion(
    //     type: PlotRegionType.main,
    //     yAxisSettings: widget.yAxisSettings!,
    //     layers: [
    //       CandleData(candles: widget.candles),
    //       ChartPointer(pointOffset: const Offset(2, 4000)),
    //       TrendLine(from: const Offset(2, 3600), to: const Offset(8, 4200)),
    //       HorizontalLine(value: 3500),
    //       RectArea(
    //           topLeft: const Offset(15, 3600),
    //           bottomRight: const Offset(29, 3500)),
    //       Label(
    //           pos: const Offset(0, 4200),
    //           label: "Hey this is text",
    //           textStyle: const TextStyle(color: Colors.red, fontSize: 16))
    //     ]));

    // regions.add(PlotRegion(
    //     type: PlotRegionType.main,
    //     yAxisSettings: widget.yAxisSettings!,
    //     layers: [
    //       SmoothLineData(candles: widget.candles),
    //       ChartPointer(pointOffset: const Offset(2, 4000)),
    //     ]));

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

  void addLater() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      regions.add(PlotRegion(
          type: PlotRegionType.indicator,
          yAxisSettings: widget.yAxisSettings!,
          yMinValue: 0,
          yMaxValue: 100,
          layers: [
            LineData(
                candles: widget.candles
                    .map((e) => ICandle(
                        id: e.id,
                        date: e.date,
                        open: e.open / 100,
                        high: e.high / 100,
                        low: e.low / 100,
                        close: e.close / 100,
                        volume: e.volume))
                    .toList()),
            HorizontalLine(value: 3500),
          ]));
    });
  }

  void addRegion(PlotRegion region) {
    setState(() {
      region.updateData(currentData);
      regions.add(region);
    });
  }

  void addData(List<ICandle> newData) {
    setState(() {
      currentData.addAll(newData);
      for (int i = 0; i < regions.length; i++) {
        regions[i].updateData(currentData);
      }
    });
  }

  recalculate(BoxConstraints constraints, List<PlotRegion> regions) {
    if (regions.isEmpty) {
      regions.add(PlotRegion(
          type: PlotRegionType.data,
          yAxisSettings: widget.yAxisSettings!,
          layers: [CandleData(candles: [])]));
    }
    (double, double) range = findMinMaxWithPercentage(widget.candles);
    yMinValue = range.$1;
    yMaxValue = range.$2;

    for (int i = 0; i < regions.length; i++) {
      List<double> yValues = generateNiceAxisValues(
          regions[i].type == PlotRegionType.data
              ? yMinValue
              : regions[i].yMinValue,
          regions[i].type == PlotRegionType.data
              ? yMaxValue
              : regions[i].yMaxValue);

      regions[i].yMinValue = yValues.first;
      regions[i].yMaxValue = yValues.last;

      Size yLabelSize = getLargetRnderBoxSizeForList(
          yValues.map((v) => v.toString()).toList(),
          widget.yAxisSettings!.axisTextStyle);

      if (yLabelSize.width > yLabelWidth) {
        yLabelWidth = yLabelSize.width;
      }
    }

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

    double totalHeight = bottomPos - topPos;
    int sections = regions.isEmpty ? 1 : regions.length;
    for (int i = 0; i < regions.length; i++) {
      regions[i].updateRegionProp(
          leftPos: leftPos,
          topPos: topPos + totalHeight / sections * i,
          rightPos: rightPos,
          bottomPos: topPos + totalHeight / sections * (i + 1),
          xStepWidth: xStepWidth,
          xOffset: xOffset,
          yMinValue: regions[i].yMinValue,
          yMaxValue: regions[i].yMaxValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: widget.padding,
        child: LayoutBuilder(builder: (context, constraints) {
          recalculate(constraints, regions);
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
                    xAxisSettings: widget.xAxisSettings!,
                    yAxisSettings: widget.yAxisSettings!,
                    xOffset: xOffset,
                    xStepWidth: xStepWidth,
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
        xStepWidth / 2 + (currentData.length - 1) * xStepWidth;

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
