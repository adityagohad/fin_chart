import 'package:fin_chart/models/enums/candle_state.dart';
import 'package:fin_chart/models/fundamental/fundamental_event.dart';
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:fin_chart/utils/constants.dart';
import 'package:flutter/material.dart';


class MainPlotRegion extends PlotRegion {
  final List<ICandle> candles;
  final List<Indicator> indicators = [];
  final List<FundamentalEvent> fundamentalEvents;
  FundamentalEvent? selectedEvent;

  MainPlotRegion(
      {String? id, required this.candles, required super.yAxisSettings, this.fundamentalEvents = const []})
      : super(id: id ?? generateV4()) {
    (double, double) range = findMinMaxWithPercentage(candles);
    yMinValue = range.$1;
    yMaxValue = range.$2;

    yValues = generateNiceAxisValues(yMinValue, yMaxValue);

    yMinValue = yValues.first;
    yMaxValue = yValues.last;

    yLabelSize = getLargetRnderBoxSizeForList(
        yValues.map((v) => v.toString()).toList(), yAxisSettings.axisTextStyle);
  }

  @override
  void updateRegionProp(
      {required double leftPos,
      required double topPos,
      required double rightPos,
      required double bottomPos,
      required double xStepWidth,
      required double xOffset,
      required double yMinValue,
      required double yMaxValue}) {
    for (Indicator indicator in indicators) {
      indicator.updateRegionProp(
          leftPos: leftPos,
          topPos: topPos,
          rightPos: rightPos,
          bottomPos: bottomPos,
          xStepWidth: xStepWidth,
          xOffset: xOffset,
          yMinValue: yMinValue,
          yMaxValue: yMaxValue);
    }
    super.updateRegionProp(
        leftPos: leftPos,
        topPos: topPos,
        rightPos: rightPos,
        bottomPos: bottomPos,
        xStepWidth: xStepWidth,
        xOffset: xOffset,
        yMinValue: yMinValue,
        yMaxValue: yMaxValue);
  }

  @override
  void updateData(List<ICandle> data) {
    candles.addAll(data.sublist(candles.isEmpty ? 0 : candles.length));
    (double, double) range = findMinMaxWithPercentage(candles);
    yMinValue = range.$1;
    yMaxValue = range.$2;

    yValues = generateNiceAxisValues(yMinValue, yMaxValue);

    yMinValue = yValues.first;
    yMaxValue = yValues.last;

    yLabelSize = getLargetRnderBoxSizeForList(
        yValues.map((v) => v.toString()).toList(), yAxisSettings.axisTextStyle);

    for (Indicator indicator in indicators) {
      indicator.updateData(data);
    }
  }

  @override
  void drawBaseLayer(Canvas canvas) {
    for (int i = 0; i < candles.length; i++) {
      ICandle candle = candles[i];
      Color candleColor;
      if (candle.state == CandleState.selected) {
        candleColor = Colors.orange;
      } else if (candle.state == CandleState.highlighted) {
        candleColor = Colors.purple;
      } else if (candle.open < candle.close) {
        candleColor = Colors.green;
      } else {
        candleColor = Colors.red;
      }

      Paint paint = Paint()
        ..strokeWidth = 2
        ..style = PaintingStyle.fill
        ..color = candleColor;

      canvas.drawLine(Offset(toX(i.toDouble()), toY(candle.high)),
          Offset(toX(i.toDouble()), toY(candle.low)), paint);

      canvas.drawRect(
          Rect.fromLTRB(toX(i.toDouble()) - (xStepWidth) / 4, toY(candle.open),
              toX(i.toDouble()) + (xStepWidth) / 4, toY(candle.close)),
          paint);

      // if (toX(i) >= leftPos && toX(i) <= rightPos) {
      //   canvas.drawLine(Offset(toX(i), toY(candle.high)),
      //       Offset(toX(i), toY(candle.low)), paint);

      //   canvas.drawRect(
      //       Rect.fromLTRB(toX(i) - candleWidth / 2, toY(candle.open),
      //           toX(i) + candleWidth / 2, toY(candle.close)),
      //       paint);
      // }
      // if (toX(i) > rightPos) {
      //   break;
      // }
    }

    for (Indicator indicator in indicators) {
      indicator.drawIndicator(canvas: canvas);
    }
    drawFundamentalEvents(canvas);
  }

  @override
  void drawYAxis(Canvas canvas) {
    double valuseDiff = yValues.last - yValues.first;
    double posDiff = bottomPos - topPos;

    for (double value in yValues) {
      double pos = bottomPos - (value - yValues.first) * posDiff / valuseDiff;

      if (!(value == yValues.first || value == yValues.last)) {
        canvas.drawLine(Offset(leftPos, pos), (Offset(rightPos, pos)), Paint());
        final TextPainter text = TextPainter(
          text: TextSpan(
            text: value.toStringAsFixed(2),
            style: yAxisSettings.axisTextStyle,
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        if (yAxisSettings.yAxisPos == YAxisPos.left) {
          text.paint(
              canvas,
              Offset(leftPos - (text.width + yLabelPadding / 2),
                  pos - text.height / 2));
        }
        if (yAxisSettings.yAxisPos == YAxisPos.right) {
          text.paint(canvas,
              Offset(rightPos + yLabelPadding / 2, pos - text.height / 2));
        }
      }
    }

    if (yAxisSettings.yAxisPos == YAxisPos.left) {
      canvas.drawLine(
          Offset(leftPos, topPos),
          Offset(leftPos, bottomPos),
          Paint()
            ..color = yAxisSettings.axisColor
            ..strokeWidth = yAxisSettings.strokeWidth);
    }
    if (yAxisSettings.yAxisPos == YAxisPos.right) {
      canvas.drawLine(
          Offset(rightPos, topPos),
          Offset(rightPos, bottomPos),
          Paint()
            ..color = yAxisSettings.axisColor
            ..strokeWidth = yAxisSettings.strokeWidth);
    }
  }

  @override
  Widget renderIndicatorToolTip(
      {required Indicator? selectedIndicator,
      required Function(Indicator)? onClick,
      required Function()? onSettings,
      required Function()? onDelete}) {
    return Positioned(
        left: leftPos,
        top: topPos,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...indicators.map((indicator) => indicator.indicatorToolTip(
                selectedIndicator: selectedIndicator,
                onClick: onClick,
                onSettings: onSettings,
                onDelete: onDelete))
          ],
        ));
  }

  
  void drawFundamentalEvents(Canvas canvas) {
    if (fundamentalEvents.isEmpty) return;

    // Loop through events
    for (final event in fundamentalEvents) {
      // Find the index of the candle closest to event date
      int index = _findCandleIndexForDate(event.date);

      // Skip events that don't have a corresponding candle or fall outside visible range
      if (index < 0) continue;

      // Calculate x position
      final xPos = leftPos + xOffset + xStepWidth / 2 + index * xStepWidth;

      // Skip if outside visible area
      if (xPos < leftPos || xPos > rightPos) continue;
      final yPos = bottomPos - 20; // Position below x-axis

      // Set position for later tooltip reference
      event.position = Offset(xPos, yPos);

      // Draw event icon with larger size for visibility
      final paint = Paint()
        ..color = event.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(event.position!, 12, paint); // Increased size

      // Draw event text with white background for contrast
      final textSpan = TextSpan(
        text: event.iconText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12, // Increased size
          fontWeight: FontWeight.bold,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          event.position!.dx - textPainter.width / 2,
          event.position!.dy - textPainter.height / 2,
        ),
      );

      // If selected, draw tooltip
      if (event.isSelected) {
        _drawEventTooltip(canvas, event);
      }
    }
  }

int _findCandleIndexForDate(DateTime date) {
    // Find the closest candle to the event date
    for (int i = 0; i < candles.length; i++) {
      final candle = candles[i];
      if (isSameDay(candle.date, date)) {
        return i;
      }
    }
    return -1;
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _drawEventTooltip(Canvas canvas, FundamentalEvent event) {
    event.drawTooltip(canvas);
  }

// // Helper method to format date
//   String _formatDate(DateTime date) {
//     return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
//   }

// // Helper method to format currency
//   String _formatCurrency(double value) {
//     if (value >= 1000000000) {
//       return '\$${(value / 1000000000).toStringAsFixed(2)}B';
//     } else if (value >= 1000000) {
//       return '\$${(value / 1000000).toStringAsFixed(2)}M';
//     } else if (value >= 1000) {
//       return '\$${(value / 1000).toStringAsFixed(2)}K';
//     } else {
//       return '\$${value.toStringAsFixed(2)}';
//     }
//   }

  void handleEventTap(Offset tapPosition) {
    selectedEvent = null;
    for (var event in fundamentalEvents) {
      if (event.position != null &&
          (event.position! - tapPosition).distance < 20) {
        event.isSelected = true;
        selectedEvent = event;
      } else {
        event.isSelected = false;
      }
    }
  }

  void updateFundamentalEvents(List<FundamentalEvent> newEvents) {
    fundamentalEvents.addAll(newEvents);
  }
}
