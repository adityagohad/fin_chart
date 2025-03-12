import 'package:flutter/material.dart';
import 'package:fin_chart/models/enums/plot_region_type.dart';

class RegionDialog extends StatefulWidget {
  final Function(PlotRegionType type, String variety, double yMin, double yMax)
      onSubmit;

  const RegionDialog({super.key, required this.onSubmit});

  @override
  State<RegionDialog> createState() => _RegionDialogState();
}

class _RegionDialogState extends State<RegionDialog> {
  PlotRegionType? selectedRegionType;
  String? selectedVariety;
  bool inputsValid = false;

  List<String> getVarietyOptions() {
    if (selectedRegionType == PlotRegionType.data) {
      return ['Candle', 'Line'];
    } else if (selectedRegionType == PlotRegionType.indicator) {
      return ['RSI', 'MACD', 'Stochastic'];
    }
    return [];
  }

  void validateInputs() {
    bool isValid = selectedRegionType != null && selectedVariety != null;

    if (isValid != inputsValid) {
      setState(() {
        inputsValid = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Region'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Region Type Dropdown
            const Text('Region Type'),
            DropdownButton<PlotRegionType>(
              isExpanded: true,
              value: selectedRegionType,
              hint: const Text('Select Region Type'),
              onChanged: (PlotRegionType? value) {
                setState(() {
                  selectedRegionType = value;
                  selectedVariety =
                      null; // Reset variety when region type changes
                });
                validateInputs();
              },
              items: PlotRegionType.values.map((PlotRegionType type) {
                return DropdownMenuItem<PlotRegionType>(
                  value: type,
                  child: Text(type.name.capitalize()),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Variety Dropdown (shown only when region type is selected)
            if (selectedRegionType != null) ...[
              const Text('Variety'),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedVariety,
                hint: const Text('Select Variety'),
                onChanged: (String? value) {
                  setState(() {
                    selectedVariety = value;
                  });
                  validateInputs();
                },
                items: getVarietyOptions().map((String variety) {
                  return DropdownMenuItem<String>(
                    value: variety,
                    child: Text(variety),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: inputsValid
              ? () {
                  double yMin = 0, yMax = 100; // Default values

                  widget.onSubmit(
                    selectedRegionType!,
                    selectedVariety!,
                    yMin,
                    yMax,
                  );
                  Navigator.of(context).pop();
                }
              : null,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

// Simple extension to capitalize the first letter
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
