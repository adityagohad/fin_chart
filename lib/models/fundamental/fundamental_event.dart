import 'package:fin_chart/models/enums/event_type.dart';
import 'package:flutter/material.dart';

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

class EarningsEvent extends FundamentalEvent {
  final double? epsActual;
  final double? epsEstimate;
  final double? epsSurprise;
  final double? revenueActual;
  final double? revenueEstimate;
  final double? revenueSurprise;

  EarningsEvent({
    required super.id,
    required super.date,
    required super.title,
    super.description,
    this.epsActual,
    this.epsEstimate,
    this.epsSurprise,
    this.revenueActual,
    this.revenueEstimate,
    this.revenueSurprise,
  }) : super(type: EventType.earnings);

  @override
  Color get color => epsSurprise != null && epsSurprise! > 0 ? Colors.green : Colors.red;

  @override
  String get iconText => 'E';

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'date': date.toIso8601String(),
      'title': title,
      'description': description,
      if (epsActual != null) 'actual': epsActual,
      if (epsEstimate != null) 'estimate': epsEstimate,
      if (epsSurprise != null) 'surprise': epsSurprise,
      if (revenueActual != null) 'revenueActual': revenueActual,
      if (revenueEstimate != null) 'revenueEstimate': revenueEstimate,
      if (revenueSurprise != null) 'revenueSurprise': revenueSurprise,
    };
  }

  factory EarningsEvent.fromJson(Map<String, dynamic> json) {
    return EarningsEvent(
      id: json['id'],
      date: DateTime.parse(json['date']),
      title: json['title'],
      description: json['description'] ?? '',
      epsActual: json['actual'],
      epsEstimate: json['estimate'],
      epsSurprise: json['surprise'],
      revenueActual: json['revenueActual'],
      revenueEstimate: json['revenueEstimate'],
      revenueSurprise: json['revenueSurprise'],
    );
  }
}

class DividendEvent extends FundamentalEvent {
  final double amount;
  final String currency;

  DividendEvent({
    required super.id,
    required super.date,
    required super.title,
    required this.amount,
    required this.currency,
    super.description,
  }) : super(type: EventType.dividend);

  @override
  Color get color => Colors.blue;

  @override
  String get iconText => 'D';

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'date': date.toIso8601String(),
      'title': title,
      'description': description,
      'amount': amount,
      'currency': currency,
    };
  }

  factory DividendEvent.fromJson(Map<String, dynamic> json) {
    return DividendEvent(
      id: json['id'],
      date: DateTime.parse(json['date']),
      title: json['title'],
      description: json['description'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] ?? 'USD',
    );
  }
}

class StockSplitEvent extends FundamentalEvent {
  final String ratio; // e.g., "2:1" or "3:2"

  StockSplitEvent({
    required super.id,
    required super.date,
    required super.title,
    required this.ratio,
    super.description,
  }) : super(type: EventType.stockSplit);

  @override
  Color get color => Colors.purple;

  @override
  String get iconText => 'S';

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'date': date.toIso8601String(),
      'title': title,
      'description': description,
      'ratio': ratio,
    };
  }

  factory StockSplitEvent.fromJson(Map<String, dynamic> json) {
    return StockSplitEvent(
      id: json['id'],
      date: DateTime.parse(json['date']),
      title: json['title'],
      description: json['description'] ?? '',
      ratio: json['ratio'] ?? '1:1',
    );
  }
}