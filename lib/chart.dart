import 'package:fin_chart/chart_painter.dart';
import 'package:fin_chart/models/enums/data_fit_type.dart';
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/layers/candle_data.dart';
import 'package:fin_chart/models/layers/layer.dart';
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
  List<PlotRegion> selectedRegionForResize = [];

  @override
  void initState() {
    super.initState();
    regions.addAll(widget.regions);
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

  void addRegion(PlotRegion region) {
    setState(() {
      double addRegionWeight = 1 / (regions.length + 1);
      double multiplier = 1 - addRegionWeight;

      _updateRegionBounds(multiplier);

      region.updateData(currentData);
      region.updateRegionProp(
          leftPos: leftPos,
          topPos: topPos + (bottomPos - topPos) * multiplier,
          rightPos: rightPos,
          bottomPos: bottomPos,
          xStepWidth: xStepWidth,
          xOffset: xOffset,
          yMinValue: region.yMinValue,
          yMaxValue: region.yMaxValue);

      regions.add(region);
    });
  }

  void addLayer(Layer layer) {
    setState(() {
      regions[0].layers.add(layer);
      regions[0].updateData(currentData);
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

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: widget.padding,
        child: LayoutBuilder(builder: (context, constraints) {
          _recalculate(constraints, regions);
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
                    xOffset: xOffset,
                    xStepWidth: xStepWidth,
                    dataLength: currentData.length,
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
      xOffset = (xOffset + dampedVelocity).clamp(_getMaxLeftOffset(), 0);

      if (progress >= 1.0) {
        _isAnimating = false;
        _swipeVelocity = 0;
      }
    });
  }

  double _getMaxLeftOffset() {
    if (currentData.isEmpty) return 0;

    double lastCandlePosition =
        xStepWidth / 2 + (currentData.length - 1) * xStepWidth;

    if (lastCandlePosition < (rightPos - leftPos) / 2) {
      return 0;
    } else {
      return -lastCandlePosition + (rightPos - leftPos) / 2;
    }
  }

  _updateRegionBounds(double multiplier) {
    double totalHeight = (bottomPos - topPos) * multiplier;
    double tempTopPos = topPos;
    for (int i = 0; i < regions.length; i++) {
      double height = totalHeight *
          (regions[i].bottomPos - regions[i].topPos) /
          (bottomPos - topPos);
      regions[i].updateRegionProp(
          leftPos: leftPos,
          topPos: tempTopPos,
          rightPos: rightPos,
          bottomPos: tempTopPos + height,
          xStepWidth: xStepWidth,
          xOffset: xOffset,
          yMinValue: regions[i].yMinValue,
          yMaxValue: regions[i].yMaxValue);
      tempTopPos = tempTopPos + height;
    }
  }

  _recalculate(BoxConstraints constraints, List<PlotRegion> regions) {
    if (regions.isEmpty) {
      regions.add(PlotRegion(
          type: PlotRegionType.data,
          yAxisSettings: widget.yAxisSettings!,
          layers: [CandleData(candles: [])]));
    }
    (double, double) range = findMinMaxWithPercentage(currentData);
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

    if (regions.length == 1) {
      regions[0].updateRegionProp(
          leftPos: leftPos,
          topPos: regions.length == 1 ? topPos : regions[0].topPos,
          rightPos: rightPos,
          bottomPos: regions.length == 1 ? bottomPos : regions[0].bottomPos,
          xStepWidth: xStepWidth,
          xOffset: xOffset,
          yMinValue: regions[0].yMinValue,
          yMaxValue: regions[0].yMaxValue);
    }

    _updateRegionBounds(1);
  }

  _handleSwipeEnd(ScaleEndDetails details) {
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
      if (selectedRegionForResize.length < 2) {
        if (region.isRegionReadyForResize(details.localPosition) != null) {
          selectedRegionForResize.add(region);
        }
      }
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
      selectedRegionForResize.clear();
    });
  }

  _onScaleUpdate(ScaleUpdateDetails details, BoxConstraints constraints) {
    setState(() {
      if (details.pointerCount == 1) {
        if (selectedLayer == null) {
          if (selectedRegionForResize.length == 2) {
            selectedRegionForResize[0].updateRegionProp(
                leftPos: leftPos,
                topPos: selectedRegionForResize[0].topPos,
                rightPos: rightPos,
                bottomPos: selectedRegionForResize[0].bottomPos +
                    details.focalPointDelta.dy,
                xStepWidth: xStepWidth,
                xOffset: xOffset,
                yMinValue: selectedRegionForResize[0].yMinValue,
                yMaxValue: selectedRegionForResize[0].yMaxValue);

            selectedRegionForResize[1].updateRegionProp(
                leftPos: leftPos,
                topPos: selectedRegionForResize[1].topPos +
                    details.focalPointDelta.dy,
                rightPos: rightPos,
                bottomPos: selectedRegionForResize[1].bottomPos,
                xStepWidth: xStepWidth,
                xOffset: xOffset,
                yMinValue: selectedRegionForResize[1].yMinValue,
                yMaxValue: selectedRegionForResize[1].yMaxValue);
          }
          _isAnimating = false; // Stop any ongoing animation
          xOffset = (xOffset + details.focalPointDelta.dx)
              .clamp(_getMaxLeftOffset(), 0);
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
              currentData.length *
              focalPointRatio;
          xOffset = (xOffset - offsetAdjustment).clamp(_getMaxLeftOffset(), 0);
        }

        horizontalScale = newScale;
        lastFocalPoint = details.localFocalPoint;
        xStepWidth = (candleWidth * 2) * horizontalScale;
      }
    });
  }
}
