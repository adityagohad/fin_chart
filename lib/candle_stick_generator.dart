import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';

// Add enum for trendline visibility states
enum TrendlineVisibility {
  visible,
  translucent,
  invisible;

  String get label {
    switch (this) {
      case TrendlineVisibility.visible:
        return 'VISIBLE';
      case TrendlineVisibility.translucent:
        return 'TRANSLUCENT';
      case TrendlineVisibility.invisible:
        return 'INVISIBLE';
    }
  }
}

class CandleData {
  final double open;
  final double high;
  final double low;
  final double close;
  final bool isAdjusted; // Track if this candle has been manually adjusted

  CandleData({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    this.isAdjusted = false,
  });

  CandleData copyWith({
    double? open,
    double? high,
    double? low,
    double? close,
    bool? isAdjusted,
  }) {
    return CandleData(
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      close: close ?? this.close,
      isAdjusted: isAdjusted ?? this.isAdjusted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'open': open,
      'high': high,
      'low': low,
      'close': close,
      'isAdjusted': isAdjusted,
    };
  }
}

class CandleStickGenerator extends StatefulWidget {
  final Function(List<CandleData> candles) onCandleDataGenerated;
  const CandleStickGenerator({super.key, required this.onCandleDataGenerated});

  @override
  State<CandleStickGenerator> createState() => _CandleStickGeneratorState();
}

class _CandleStickGeneratorState extends State<CandleStickGenerator> {
  final TextEditingController minController =
      TextEditingController(text: '1500');
  final TextEditingController maxController =
      TextEditingController(text: '6150');
  final TextEditingController candlesController =
      TextEditingController(text: '100');

  // Add visibility state
  TrendlineVisibility trendlineVisibility = TrendlineVisibility.visible;

  List<math.Point> trendPoints = [
    const math.Point(0, 0.5),
    const math.Point(1, 0.5)
  ];
  List<CandleData> candles = [];
  int? selectedPointIndex;
  int? selectedCandleIndex;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool _isNumberKeyPressed = false;
  int? _activeNumberKey;

  void _handleKeyDown(KeyEvent event) {
    // Check for number keys 1-4
    if (event.logicalKey.keyLabel.length == 1 &&
        "1234".contains(event.logicalKey.keyLabel)) {
      _isNumberKeyPressed = true;
      _activeNumberKey = int.parse(event.logicalKey.keyLabel);
      return;
    }

    _adjustSelectedCandle(event.logicalKey);
  }

  void _handleKeyUp(KeyEvent event) {
    if (event.logicalKey.keyLabel.length == 1 &&
        "1234".contains(event.logicalKey.keyLabel)) {
      _isNumberKeyPressed = false;
      _activeNumberKey = null;
    }
  }

  void _adjustSelectedCandle(LogicalKeyboardKey key) {
    if (selectedCandleIndex == null) return;

    final adjustmentStep = (maxController.text.isEmpty
            ? 150.0
            : double.parse(maxController.text) -
                (minController.text.isEmpty
                    ? 50.0
                    : double.parse(minController.text))) *
        0.01;

    setState(() {
      final oldCandle = candles[selectedCandleIndex!];
      CandleData? newCandle;

      if (_isNumberKeyPressed && _activeNumberKey != null) {
        switch (_activeNumberKey) {
          case 1: // Open
            if (key == LogicalKeyboardKey.arrowUp) {
              newCandle = oldCandle.copyWith(
                open: oldCandle.open + adjustmentStep,
              );
            } else if (key == LogicalKeyboardKey.arrowDown) {
              newCandle = oldCandle.copyWith(
                open: oldCandle.open - adjustmentStep,
              );
            }
            break;

          case 2: // High
            if (key == LogicalKeyboardKey.arrowUp) {
              newCandle = oldCandle.copyWith(
                high: oldCandle.high + adjustmentStep,
              );
            } else if (key == LogicalKeyboardKey.arrowDown) {
              final minValue = math.max(oldCandle.open, oldCandle.close);
              final newHigh = oldCandle.high - adjustmentStep;
              if (newHigh > minValue) {
                newCandle = oldCandle.copyWith(high: newHigh);
              }
            }
            break;

          case 3: // Low
            if (key == LogicalKeyboardKey.arrowUp) {
              final maxValue = math.min(oldCandle.open, oldCandle.close);
              final newLow = oldCandle.low + adjustmentStep;
              if (newLow < maxValue) {
                newCandle = oldCandle.copyWith(low: newLow);
              }
            } else if (key == LogicalKeyboardKey.arrowDown) {
              newCandle = oldCandle.copyWith(
                low: oldCandle.low - adjustmentStep,
              );
            }
            break;

          case 4: // Close
            if (key == LogicalKeyboardKey.arrowUp) {
              newCandle = oldCandle.copyWith(
                close: oldCandle.close + adjustmentStep,
              );
            } else if (key == LogicalKeyboardKey.arrowDown) {
              newCandle = oldCandle.copyWith(
                close: oldCandle.close - adjustmentStep,
              );
            }
            break;
        }
      } else {
        if (key == LogicalKeyboardKey.arrowLeft) {
          selectedCandleIndex = math.max(0, selectedCandleIndex! - 1);
          return;
        } else if (key == LogicalKeyboardKey.arrowRight) {
          selectedCandleIndex =
              math.min(candles.length - 1, selectedCandleIndex! + 1);
          return;
        } else if (key == LogicalKeyboardKey.escape) {
          selectedCandleIndex = null;
          return;
        }
      }

      candles[selectedCandleIndex!] = newCandle!;
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      _handleKeyDown(event);
    } else if (event is KeyUpEvent) {
      _handleKeyUp(event);
    }
  }

  void _saveAdjustment() {
    if (selectedCandleIndex == null) return;

    setState(() {
      candles[selectedCandleIndex!] = candles[selectedCandleIndex!].copyWith(
        isAdjusted: true,
      );
    });
  }

  void _toggleTrendlineVisibility() {
    setState(() {
      final values = TrendlineVisibility.values;
      final currentIndex = values.indexOf(trendlineVisibility);
      trendlineVisibility = values[(currentIndex + 1) % values.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Card(
        margin: const EdgeInsets.all(4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: minController,
                      decoration: const InputDecoration(
                        labelText: 'Min Value',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: maxController,
                      decoration: const InputDecoration(
                        labelText: 'Max Value',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: candlesController,
                      decoration: const InputDecoration(
                        labelText: 'Count',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onTapDown: (details) {
                        _selectCandle(
                            details.localPosition, constraints.biggest);
                      },
                      onDoubleTapDown: (details) {
                        if (trendlineVisibility ==
                            TrendlineVisibility.visible) {
                          _handleDoubleTap(
                              details.localPosition, constraints.biggest);
                        }
                      },
                      onPanDown: (details) {
                        if (trendlineVisibility ==
                            TrendlineVisibility.visible) {
                          _selectPoint(
                              details.localPosition, constraints.biggest);
                        }
                      },
                      onPanUpdate: (details) {
                        if (trendlineVisibility ==
                            TrendlineVisibility.visible) {
                          _updatePointPosition(
                              details.localPosition, constraints.biggest);
                        }
                      },
                      onPanEnd: (_) {
                        setState(() {
                          selectedPointIndex = null;
                        });
                      },
                      onPanCancel: () {
                        setState(() {
                          selectedPointIndex = null;
                        });
                      },
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: TrendLinePainter(
                          points: trendPoints,
                          candles: candles,
                          selectedPointIndex: selectedPointIndex,
                          selectedCandleIndex: selectedCandleIndex,
                          visibility: trendlineVisibility,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed:
                          selectedCandleIndex != null ? _saveAdjustment : null,
                      child: const Text('Save Adjustment'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: _toggleTrendlineVisibility,
                      child: Text('Trendline: ${trendlineVisibility.label}'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _generateCandles,
                      child: const Text('Generate'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectCandle(Offset position, Size size) {
    final candleWidth = size.width / (candles.length + 1);
    final x = position.dx;

    final candleIndex = ((x / candleWidth) - 0.5).round() - 1;

    setState(() {
      if (candleIndex >= 0 && candleIndex < candles.length) {
        selectedCandleIndex = candleIndex;
      } else {
        selectedCandleIndex = null;
      }
    });
  }

  void _generateCandles() {
    final min = double.parse(minController.text);
    final max = double.parse(maxController.text);
    final numCandles = int.parse(candlesController.text);
    final random = math.Random();

    setState(() {
      final newCandles = <CandleData>[];
      double lastClose = (max + min) / 2;

      for (int i = 0; i < numCandles; i++) {
        // If there's an existing adjusted candle at this index, keep it
        if (i < candles.length && candles[i].isAdjusted) {
          newCandles.add(candles[i]);
          continue;
        }

        final x = i / (numCandles - 1);
        final trendValue = 1 - _interpolateTrendValue(x);
        final range = (max - min) * 0.1;

        final open = lastClose + (random.nextDouble() - 0.5) * range * 0.5;
        final targetPrice = min + (max - min) * trendValue;
        final close = targetPrice + (random.nextDouble() - 0.5) * range;

        final high = math.max(open, close) + random.nextDouble() * range * 0.5;
        final low = math.min(open, close) - random.nextDouble() * range * 0.5;

        newCandles.add(CandleData(
          open: open,
          high: high,
          low: low,
          close: close,
        ));

        lastClose = close;
      }

      candles = newCandles;
      widget.onCandleDataGenerated(candles);
    });
  }

  void _handleDoubleTap(Offset position, Size size) {
    // Convert position to relative coordinates
    final x = position.dx / size.width;
    final y = position.dy / size.height;

    // Check if there's an existing point nearby
    int? nearbyPointIndex;
    double minDistance = double.infinity;

    for (int i = 0; i < trendPoints.length; i++) {
      final point = trendPoints[i];
      final dx = (point.x * size.width) - position.dx;
      final dy = (point.y * size.height) - position.dy;
      final distance = math.sqrt(dx * dx + dy * dy);

      if (distance < 20 && distance < minDistance) {
        // 20 pixels threshold
        minDistance = distance;
        nearbyPointIndex = i;
      }
    }

    setState(() {
      if (nearbyPointIndex != null) {
        // Don't remove first or last point
        if (nearbyPointIndex > 0 && nearbyPointIndex < trendPoints.length - 1) {
          _removeTrendPoint(nearbyPointIndex);
        }
      } else {
        _addTrendPoint(position, size);
      }
    });
  }

  void _removeTrendPoint(int index) {
    setState(() {
      trendPoints.removeAt(index);
      _generateCandles(); // Regenerate candles after removing point
    });
  }

  void _selectPoint(Offset position, Size size) {
    int? closest;
    double minDistance = double.infinity;

    for (int i = 0; i < trendPoints.length; i++) {
      final point = trendPoints[i];
      final dx = (point.x * size.width) - position.dx;
      final dy = (point.y * size.height) - position.dy;
      final distance = math.sqrt(dx * dx + dy * dy);

      if (distance < 20 && distance < minDistance) {
        minDistance = distance;
        closest = i;
      }
    }

    setState(() {
      selectedPointIndex = closest;
    });
  }

  void _updatePointPosition(Offset position, Size size) {
    if (selectedPointIndex == null) return;

    double x = position.dx / size.width;
    double y = position.dy / size.height;

    y = y.clamp(0.0, 1.0).toDouble();

    setState(() {
      if (selectedPointIndex == 0) {
        trendPoints[0] = math.Point(0, y);
      } else if (selectedPointIndex == trendPoints.length - 1) {
        trendPoints[trendPoints.length - 1] = math.Point(1.0, y);
      } else {
        final prevX = trendPoints[selectedPointIndex! - 1].x;
        final nextX = trendPoints[selectedPointIndex! + 1].x;
        x = x.clamp(prevX, nextX).toDouble();
        trendPoints[selectedPointIndex!] = math.Point(x, y);
      }

      _generateCandles();
    });
  }

  void _addTrendPoint(Offset position, Size size) {
    final x = position.dx / size.width;
    final y = position.dy / size.height;

    setState(() {
      trendPoints.add(math.Point(x.clamp(0.0, 1.0), y.clamp(0.0, 1.0)));
      trendPoints.sort((a, b) => (a.x - b.x).sign.toInt());
    });
  }

  double _interpolateTrendValue(double x) {
    int i = 0;
    while (i < trendPoints.length - 1 && trendPoints[i + 1].x < x) {
      i++;
    }

    if (i >= trendPoints.length - 1) {
      return trendPoints.last.y.toDouble();
    }

    final p1 = trendPoints[i];
    final p2 = trendPoints[i + 1];

    final t = (x - p1.x) / (p2.x - p1.x);
    return p1.y + t * (p2.y - p1.y);
  }
}

class TrendLinePainter extends CustomPainter {
  final List<math.Point> points;
  final List<CandleData> candles;
  final int? selectedPointIndex;
  final int? selectedCandleIndex;
  final TrendlineVisibility visibility;

  TrendLinePainter({
    required this.points,
    required this.candles,
    required this.visibility,
    this.selectedPointIndex,
    this.selectedCandleIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw trend line if not invisible
    if (visibility != TrendlineVisibility.invisible) {
      final linePaint = Paint()
        ..color = Colors.blue.withOpacity(
            visibility == TrendlineVisibility.translucent ? 0.3 : 1.0)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      final path = Path();

      if (points.isNotEmpty) {
        path.moveTo(
          points.first.x * size.width,
          points.first.y * size.height,
        );

        for (var point in points.skip(1)) {
          path.lineTo(
            point.x * size.width,
            point.y * size.height,
          );
        }
      }

      canvas.drawPath(path, linePaint);

      // Draw points
      if (visibility == TrendlineVisibility.visible) {
        final pointPaint = Paint()
          ..strokeWidth = 2
          ..style = PaintingStyle.fill;

        for (var i = 0; i < points.length; i++) {
          final point = points[i];
          final isSelected = i == selectedPointIndex;

          pointPaint.color = isSelected ? Colors.red : Colors.blue;

          canvas.drawCircle(
            Offset(point.x * size.width, point.y * size.height),
            isSelected ? 8 : 6,
            pointPaint,
          );
        }
      }
    }

    // Draw candles
    final candlePaint = Paint()..strokeWidth = 1;
    final candleWidth = size.width / (candles.length + 1);

    for (var i = 0; i < candles.length; i++) {
      final candle = candles[i];
      final x = candleWidth * (i + 1);
      final isSelected = i == selectedCandleIndex;

      final yHigh = _priceToY(candle.high, size.height);
      final yLow = _priceToY(candle.low, size.height);
      final yOpen = _priceToY(candle.open, size.height);
      final yClose = _priceToY(candle.close, size.height);

      // Draw wick
      canvas.drawLine(
          Offset(x, yHigh),
          Offset(x, yLow),
          Paint()
            ..color = (candle.close > candle.open ? Colors.green : Colors.red)
                .withOpacity(isSelected ? 0.5 : 1.0));

      // Draw candle body
      final bodyPaint = Paint()
        ..color = (candle.close > candle.open ? Colors.green : Colors.red)
            .withOpacity(isSelected ? 0.5 : 1.0);

      final bodyRect = Rect.fromPoints(
        Offset(x - candleWidth * 0.3, yOpen),
        Offset(x + candleWidth * 0.3, yClose),
      );

      canvas.drawRect(bodyRect, bodyPaint);

      // Draw blue border for selected candle
      if (isSelected) {
        canvas.drawRect(
          bodyRect,
          Paint()
            ..color = Colors.blue
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }
  }

  double _priceToY(double price, double height) {
    final min = double.parse(_CandleStickGeneratorState().minController.text);
    final max = double.parse(_CandleStickGeneratorState().maxController.text);
    return height * (1 - (price - min) / (max - min));
  }

  @override
  bool shouldRepaint(covariant TrendLinePainter oldDelegate) =>
      points != oldDelegate.points ||
      candles != oldDelegate.candles ||
      selectedPointIndex != oldDelegate.selectedPointIndex ||
      visibility != oldDelegate.visibility;
}
