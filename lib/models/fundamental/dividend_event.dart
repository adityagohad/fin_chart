import 'package:fin_chart/models/enums/event_type.dart';
import 'package:fin_chart/models/fundamental/fundamental_event.dart';
import 'package:flutter/material.dart';

class DividendEvent extends FundamentalEvent {
  final double amount;
  final String currency;
  final DateTime? exDividendDate;
  final DateTime? paymentDate;

  DividendEvent({
    required super.id,
    required super.date,
    required super.title,
    required this.exDividendDate,
    required this.paymentDate,
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
      'exDividendDate': exDividendDate?.toIso8601String(),
      'paymentDate': paymentDate?.toIso8601String(),
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
      exDividendDate: json['exDividendDate'] != null ? DateTime.parse(json['exDividendDate']) : null,
      paymentDate: json['paymentDate'] != null ? DateTime.parse(json['paymentDate']) : null,
      description: json['description'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] ?? 'USD',
    );
  }

  // String _formatDate(DateTime date) {
  //   return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  // }

  // @override
  // void drawTooltip(Canvas canvas) {
  //   if (!isSelected || position == null) return;

  //   List<TextSpan> textSpans = [];
    
  //   textSpans.add(const TextSpan(
  //     text: 'Dividend Announcement\n',
  //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),
  //   ));

  //   textSpans.add(TextSpan(
  //     text: 'Date: ${_formatDate(date)}\n\n',
  //     style: const TextStyle(color: Colors.black, fontSize: 11),
  //   ));

  //   textSpans.add(TextSpan(
  //     text: 'Amount: ${amount.toStringAsFixed(2)} $currency\n',
  //     style: const TextStyle(color: Colors.black, fontSize: 11),
  //   ));

  //   if (exDividendDate != null) {
  //     textSpans.add(TextSpan(
  //       text: 'Ex-Dividend Date: ${_formatDate(exDividendDate!)}\n',
  //       style: const TextStyle(color: Colors.black, fontSize: 11),
  //     ));
  //   }

  //   if (paymentDate != null) {
  //     textSpans.add(TextSpan(
  //       text: 'Payment Date: ${_formatDate(paymentDate!)}\n',
  //       style: const TextStyle(color: Colors.black, fontSize: 11),
  //     ));
  //   }

  //   if (description.isNotEmpty) {
  //     textSpans.add(TextSpan(
  //       text: '\nDetails: $description',
  //       style: const TextStyle(color: Colors.black, fontSize: 11),
  //     ));
  //   }
  // }
}