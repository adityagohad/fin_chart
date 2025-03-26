// import 'package:fin_chart/models/enums/event_type.dart';
// import 'package:fin_chart/models/fundamental/fundamental_event.dart';
// import 'package:flutter/material.dart';

// class EarningsEvent extends FundamentalEvent {
//   final double? epsActual;
//   final double? epsEstimate;
//   final double? epsSurprise;
//   final double? revenueActual;
//   final double? revenueEstimate;
//   final double? revenueSurprise;

//   EarningsEvent({
//     required super.id,
//     required super.date,
//     required super.title,
//     super.description,
//     this.epsActual,
//     this.epsEstimate,
//     this.epsSurprise,
//     this.revenueActual,
//     this.revenueEstimate,
//     this.revenueSurprise,
//   }) : super(type: EventType.earnings);

//   @override
//   Color get color => epsSurprise != null && epsSurprise! > 0 ? Colors.green : Colors.red;

//   @override
//   String get iconText => 'E';

//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'type': type.name,
//       'date': date.toIso8601String(),
//       'title': title,
//       'description': description,
//       if (epsActual != null) 'actual': epsActual,
//       if (epsEstimate != null) 'estimate': epsEstimate,
//       if (epsSurprise != null) 'surprise': epsSurprise,
//       if (revenueActual != null) 'revenueActual': revenueActual,
//       if (revenueEstimate != null) 'revenueEstimate': revenueEstimate,
//       if (revenueSurprise != null) 'revenueSurprise': revenueSurprise,
//     };
//   }

//   factory EarningsEvent.fromJson(Map<String, dynamic> json) {
//     return EarningsEvent(
//       id: json['id'],
//       date: DateTime.parse(json['date']),
//       title: json['title'],
//       description: json['description'] ?? '',
//       epsActual: json['actual'],
//       epsEstimate: json['estimate'],
//       epsSurprise: json['surprise'],
//       revenueActual: json['revenueActual'],
//       revenueEstimate: json['revenueEstimate'],
//       revenueSurprise: json['revenueSurprise'],
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
//   }

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

//   @override
//   void drawTooltip(Canvas canvas) {
//     if (!isSelected || position == null) return;

//     List<TextSpan> textSpans = [];
    
//     textSpans.add(const TextSpan(
//       text: 'Earnings Report\n',
//       style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),
//     ));
    
//     textSpans.add(TextSpan(
//       text: 'Date: ${_formatDate(date)}\n\n',
//       style: const TextStyle(color: Colors.black, fontSize: 11),
//     ));
    
//     textSpans.add(const TextSpan(
//       text: 'EPS\n',
//       style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 11),
//     ));
    
//     if (epsActual != null) {
//       textSpans.add(TextSpan(
//         text: 'Reported: ${epsActual!.toStringAsFixed(2)}\n',
//         style: const TextStyle(color: Colors.black, fontSize: 11),
//       ));
//     }
    
//     if (epsEstimate != null) {
//       textSpans.add(TextSpan(
//         text: 'Estimated: ${epsEstimate!.toStringAsFixed(2)}\n',
//         style: const TextStyle(color: Colors.black, fontSize: 11),
//       ));
//     }
    
//     // Calculate EPS surprise if both actual and estimate are available
//     if (epsActual != null && epsEstimate != null) {
//       final epsSurprise = ((epsActual! - epsEstimate!) / epsEstimate! * 100);
//       textSpans.add(TextSpan(
//         text: 'Surprise: ${epsSurprise.toStringAsFixed(2)}%\n\n',
//         style: const TextStyle(color: Colors.black, fontSize: 11),
//       ));
//     } else if (epsSurprise != null) {
//       // Use provided surprise if calculation isn't possible
//       textSpans.add(TextSpan(
//         text: 'Surprise: ${epsSurprise!.toStringAsFixed(2)}%\n\n',
//         style: const TextStyle(color: Colors.black, fontSize: 11),
//       ));
//     } else {
//       textSpans.add(const TextSpan(text: '\n'));
//     }
    
//     // Only show Revenue section if we have any revenue data
//     if (revenueActual != null || revenueEstimate != null) {
//       textSpans.add(const TextSpan(
//         text: 'Revenue\n',
//         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 11),
//       ));
      
//       if (revenueActual != null) {
//         textSpans.add(TextSpan(
//           text: 'Reported: ${_formatCurrency(revenueActual!)}\n',
//           style: const TextStyle(color: Colors.black, fontSize: 11),
//         ));
//       }
      
//       if (revenueEstimate != null) {
//         textSpans.add(TextSpan(
//           text: 'Estimated: ${_formatCurrency(revenueEstimate!)}\n',
//           style: const TextStyle(color: Colors.black, fontSize: 11),
//         ));
//       }
      
//       // Calculate revenue surprise if both actual and estimate are available
//       if (revenueActual != null && revenueEstimate != null) {
//         final revenueSurprise = ((revenueActual! - revenueEstimate!) / revenueEstimate! * 100);
//         textSpans.add(TextSpan(
//           text: 'Surprise: ${revenueSurprise.toStringAsFixed(2)}%\n',
//           style: const TextStyle(color: Colors.black, fontSize: 11),
//         ));
//       } else if (revenueSurprise != null) {
//         // Use provided surprise if calculation isn't possible
//         textSpans.add(TextSpan(
//           text: 'Surprise: ${revenueSurprise!.toStringAsFixed(2)}%\n',
//           style: const TextStyle(color: Colors.black, fontSize: 11),
//         ));
//       }
//     }
//   }
// }