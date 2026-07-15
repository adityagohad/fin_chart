import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:flutter/material.dart';

IconData getIndicatorIcon(IndicatorType type) {
  switch (type) {
    case IndicatorType.rsi:
      return Icons.speed;
    case IndicatorType.macd:
      return Icons.candlestick_chart;
    case IndicatorType.sma:
    case IndicatorType.ema:
      return Icons.auto_graph;
    case IndicatorType.bollingerBand:
      return Icons.straighten;
    case IndicatorType.stochastic:
      return Icons.show_chart;
    case IndicatorType.mfi:
      return Icons.account_balance_wallet;
    case IndicatorType.adx:
      return Icons.trending_up;
    case IndicatorType.atr:
      return Icons.gesture;
    case IndicatorType.pivotPoint:
      return Icons.horizontal_rule;
    case IndicatorType.pe:
    case IndicatorType.pb:
      return Icons.attach_money;
    case IndicatorType.supertrend:
      return Icons.alt_route;
    case IndicatorType.vwap:
      return Icons.functions;
    case IndicatorType.evEbitda:
    case IndicatorType.evSales:
      return Icons.analytics;
    case IndicatorType.scanner:
      return Icons.radar;
    case IndicatorType.roc:
      return Icons.timeline;
  }
}

IconData getLayerIcon(LayerType type) {
  switch (type) {
    case LayerType.label:
      return Icons.text_fields;
    case LayerType.horizontalLine:
      return Icons.horizontal_rule;
    case LayerType.horizontalBand:
      return Icons.straighten;
    case LayerType.trendLine:
      return Icons.show_chart;
    case LayerType.parallelChannel:
      return Icons.timeline;
    case LayerType.rectArea:
      return Icons.crop_square;
    case LayerType.circularArea:
      return Icons.circle_outlined;
    case LayerType.arrow:
      return Icons.arrow_right_alt;
    case LayerType.arrowTextPointer:
      return Icons.location_on;
    case LayerType.verticalLine:
      return Icons.format_size;
  }
}
