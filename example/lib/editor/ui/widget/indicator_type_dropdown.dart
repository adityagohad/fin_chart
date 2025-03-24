import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:flutter/material.dart';

class IndicatorTypeDropdown extends StatelessWidget {
  final IndicatorType? selectedType;
  final Function(IndicatorType) onChanged;

  const IndicatorTypeDropdown({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: DropdownButton<IndicatorType>(
        value: selectedType,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        onChanged: (IndicatorType? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        items: IndicatorType.values
            .map<DropdownMenuItem<IndicatorType>>((IndicatorType type) {
          return DropdownMenuItem<IndicatorType>(
            value: type,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(type.name),
            ),
          );
        }).toList(),
        underline: const SizedBox.shrink(),
        isExpanded: true,
        menuWidth: 250,
      ),
    );
  }
}
