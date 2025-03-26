import 'package:fin_chart/models/enums/event_type.dart';
import 'package:fin_chart/models/fundamental/dividend_event.dart';
import 'package:fin_chart/models/fundamental/stock_split_event.dart';
import 'package:flutter/material.dart';
import 'package:fin_chart/models/fundamental/earnings_event.dart';

abstract class FundamentalEvent {
  final String id;
  final EventType type;
  final DateTime date;
  final String title;
  final String description;
  Offset? position;
  bool isSelected = false;

  FundamentalEvent({
    required this.id,
    required this.type,
    required this.date,
    required this.title,
    this.description = '',
  });

  Color get color;
  String get iconText;
  void drawTooltip(Canvas canvas);

  Map<String, dynamic> toJson();

  factory FundamentalEvent.fromJson(Map<String, dynamic> json) {
    final type = (json['type'] as String).toEventType();

    switch (type) {
      case EventType.earnings:
        return EarningsEvent.fromJson(json);
      case EventType.dividend:
        return DividendEvent.fromJson(json);
      case EventType.stockSplit:
        return StockSplitEvent.fromJson(json);
    }
  }
}
