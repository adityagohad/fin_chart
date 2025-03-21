import 'package:fin_chart/chart_painter.dart';
import 'package:fin_chart/fin_chart.dart';
import 'package:fin_chart/models/enums/data_fit_type.dart';
import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/enums/plot_region_type.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/models/region/macd_plot_region.dart';
import 'package:fin_chart/models/region/main_plot_region.dart';
import 'package:fin_chart/models/region/panel_plot_region.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/models/region/stochastic_plot_region.dart';
import 'package:fin_chart/models/settings/x_axis_settings.dart';
import 'package:fin_chart/utils/constants.dart';
import 'package:flutter/material.dart';

import 'models/settings/y_axis_settings.dart';

class Chart extends StatefulWidget {
  final EdgeInsets? padding;
  final DataFit dataFit;
  final YAxisSettings? yAxisSettings;
  final XAxisSettings? xAxisSettings;
  final List<ICandle> candles;
  final Function(Offset, Offset) onInteraction;
  final Function(PlotRegion region, Layer layer)? onLayerSelect;
  final Function(PlotRegion region)? onRegionSelect;

  const Chart(
      {super.key,
      this.padding = const EdgeInsets.all(8),
      this.dataFit = DataFit.adaptiveWidth,
      required this.candles,
      required this.onInteraction,
      this.onLayerSelect,
      this.onRegionSelect,
      this.yAxisSettings = const YAxisSettings(),
      this.xAxisSettings = const XAxisSettings()});

  @override
  State<Chart> createState() => ChartState();
}

class ChartState extends State<Chart> with TickerProviderStateMixin {
  double leftPos = 0;
  double topPos = 0;
  double rightPos = 0;
  double bottomPos = 0;

  double xOffset = 0;

  double horizontalScale = 1;
  double previousHorizontalScale = 1.0;
  Offset? lastFocalPoint;

  double yLabelWidth = 21;
  double xLabelHeight = 21;

  double yMinValue = 0;
  double yMaxValue = 1;
  double xStepWidth = candleWidth * 2;

  late AnimationController _swipeAnimationController;
  double _swipeVelocity = 0;
  bool _isAnimating = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  List<PlotRegion> regions = [];

  Layer? selectedLayer;
  bool isLayerGettingAdded = false;

  List<ICandle> currentData = [];
  List<PlotRegion> selectedRegionForResize = [];
  PlotRegion? selectedRegion;

  bool isInit = true;

  @override
  void initState() {
    currentData.addAll(widget.candles);
    regions.add(MainPlotRegion(
      candles: currentData,
      yAxisSettings: widget.yAxisSettings!,
    ));
    xStepWidth = candleWidth * 2;

    _swipeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(_handleSwipeAnimation);

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    );

    super.initState();
  }

  @override
  void dispose() {
    _swipeAnimationController.dispose();
    _controller.dispose();
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

  void addIndicator(Indicator indicator) {
    setState(() {
      if (indicator.displayMode == DisplayMode.panel) {
        PanelPlotRegion region = PanelPlotRegion(
            indicator: indicator, yAxisSettings: widget.yAxisSettings!);

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
            yMinValue: indicator.yMinValue,
            yMaxValue: indicator.yMaxValue);

        regions.add(region);
      } else if (indicator.displayMode == DisplayMode.main) {
        for (PlotRegion region in regions) {
          if (region.type == PlotRegionType.data) {
            indicator.updateData(currentData);
            (region as MainPlotRegion).indicators.add(indicator);
          }
        }
      }
    });
  }

  void updateLayerGettingAddedState(LayerType layerType) {
    setState(() {
      isLayerGettingAdded = true;
    });
  }

  void addLayerUsingTool(Layer layer) {
    setState(() {
      selectedLayer = layer;
      selectedRegion?.addLayer(layer);
      isLayerGettingAdded = false;
    });
  }

  void addLayerAtRegion(String regionId, Layer layer) {
    setState(() {
      selectedLayer = layer;
      regions
          .firstWhere((region) => region.id == regionId,
              orElse: () => regions[0])
          .addLayer(layer);
      isLayerGettingAdded = false;
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

  void removeLayerById(String layerId) {
    setState(() {
      for (PlotRegion region in regions) {
        region.layers.removeWhere((layer) => layer.id == layerId);
      }
      selectedLayer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: widget.padding,
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxHeight != 0) {
            _recalculate(constraints);
          }
          return Stack(
            children: [
              SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: GestureDetector(
                  onTapDown: _onTapDown,
                  onDoubleTap: _onDoubleTap,
                  onScaleStart: _onScaleStart,
                  onScaleEnd: _onScaleEnd,
                  onScaleUpdate: (details) =>
                      _onScaleUpdate(details, constraints),
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
                        bottomPos: bottomPos,
                        data: currentData,
                        selectedLayer: selectedLayer,
                        animationValue: _animation.value),
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                  ),
                ),
              ),
              selectedLayer == null
                  ? Container()
                  : selectedLayer?.layerToolTip() ?? Container()

              // Positioned(
              //     top: 8,
              //     right: 8,
              //     child: IconButton(
              //         icon: const Icon(Icons.settings, color: Colors.blue),
              //         onPressed: () {
              //           selectedLayer?.showSettingsDialog(context, (layer) {
              //             setState(() {
              //               selectedLayer = layer;
              //             });
              //           });
              //         }),
              //   ),
            ],
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

      // if (regions[i] is PanelPlotRegion) {
      //   (regions[i] as PanelPlotRegion).indicator.updateRegionProp(
      //       leftPos: leftPos,
      //       topPos: tempTopPos,
      //       rightPos: rightPos,
      //       bottomPos: tempTopPos + height,
      //       xStepWidth: xStepWidth,
      //       xOffset: xOffset,
      //       yMinValue: regions[i].yMinValue,
      //       yMaxValue: regions[i].yMaxValue);
      // }
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

  _recalculate(BoxConstraints constraints) {
    for (PlotRegion region in regions) {
      if (region.yLabelSize.width > yLabelWidth) {
        yLabelWidth = region.yLabelSize.width;
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

    if (isInit) {
      regions[0].updateRegionProp(
          leftPos: leftPos,
          topPos: topPos,
          rightPos: rightPos,
          bottomPos: bottomPos,
          xStepWidth: xStepWidth,
          xOffset: xOffset,
          yMinValue: regions[0].yMinValue,
          yMaxValue: regions[0].yMaxValue);
    }

    isInit = false;

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
      xStepWidth = candleWidth;
      xOffset = 0;
      _isAnimating = false;
      _swipeVelocity = 0;
    });
  }

  _onTapDown(TapDownDetails details) {
    setState(() {
      if (isLayerGettingAdded) {
        _handleTapDownWhenLayerToAdd(details);
      } else {
        selectedLayer = null;
        for (PlotRegion region in regions) {
          if (selectedRegionForResize.length < 2) {
            if (region.isRegionReadyForResize(details.localPosition) != null) {
              selectedRegionForResize.add(region);
            }
          }
          PlotRegion? tempRegion = region.regionSelect(details.localPosition);
          if (tempRegion != null) {
            widget.onRegionSelect?.call(tempRegion);
          }
          for (Layer layer in region.layers) {
            if (selectedLayer == null) {
              selectedLayer = layer.onTapDown(details: details);
              if (selectedLayer != null && tempRegion != null) {
                widget.onLayerSelect?.call(tempRegion, selectedLayer!);
              }
            } else {
              //layer.onTapDown(details: details);
            }
          }
        }
      }
    });
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
        if (isLayerGettingAdded && selectedRegion != null) {
          _handleDragWhenLayerToAdd(details);
        } else if (selectedLayer == null) {
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
          } else {
            _isAnimating = false;
            xOffset = (xOffset + details.focalPointDelta.dx)
                .clamp(_getMaxLeftOffset(), 0);
          }
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
        xStepWidth = candleWidth * horizontalScale;
      }
    });
  }

  _handleTapDownWhenLayerToAdd(TapDownDetails details) {
    for (PlotRegion region in regions) {
      selectedRegion = region.regionSelect(details.localPosition);
      if (selectedRegion != null) {
        widget.onInteraction(
            selectedRegion!.getRealCoordinates(details.localPosition),
            details.localPosition);
        break;
      }
    }
  }

  _handleDragWhenLayerToAdd(ScaleUpdateDetails details) {
    widget.onInteraction(
        selectedRegion!.getRealCoordinates(details.localFocalPoint),
        details.localFocalPoint);
  }

  /// Convert chart state to JSON
  Map<String, dynamic> toJson() {
    //return {'data': currentData.map((candle) => candle.toJson()).toList()};
    return {
      'yAxisSettings': widget.yAxisSettings?.toJson(),
      'xAxisSettings': widget.xAxisSettings?.toJson(),
      'regions': regions.map((region) => region.toJson()).toList(),
      'dataFit': widget.dataFit.name,
      'data': currentData.map((candle) => candle.toJson()).toList()
    };
  }

  /// Create regions from JSON data
  void loadFromJson(Map<String, dynamic> json) {
    setState(() {
      if (json['regions'] != null) {
        regions.clear();

        for (var regionJson in json['regions']) {
          String? type = regionJson['type'];
          if (type != null) {
            PlotRegion? region;

            switch (type) {
              case 'data':
                region = MainPlotRegion.fromJson(regionJson);
                break;
              case 'indicator':
                // Determine which indicator type based on properties
                if (regionJson.containsKey('period') &&
                    !regionJson.containsKey('fastPeriod')) {
                  region = RsiPlotRegion.fromJson(regionJson);
                } else if (regionJson.containsKey('fastPeriod')) {
                  region = MACDPlotRegion.fromJson(regionJson);
                } else if (regionJson.containsKey('kPeriod')) {
                  region = StochasticPlotRegion.fromJson(regionJson);
                }
                break;
            }

            if (region != null) {
              regions.add(region);
            }
          }
        }
      }
    });
  }
}
