import 'package:fin_chart/models/enums/candle_state.dart';

class ICandle {
  final String id;
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  final String? promptText; // Additional text to display to the user
  CandleState state;

  ICandle({
    required this.id,
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    this.promptText,
    this.state = CandleState.natural,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'open': open,
      'high': high,
      'low': low,
      'close': close,
      'volume': volume,
      'promptText': promptText,
      'state': state.name,
    };
  }
}
