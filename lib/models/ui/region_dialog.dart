import 'package:flutter/material.dart';
import 'package:fin_chart/models/region/plot_region.dart';

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
  final TextEditingController yMinController = TextEditingController();
  final TextEditingController yMaxController = TextEditingController();
  bool inputsValid = false;

  List<String> getVarietyOptions() {
    if (selectedRegionType == PlotRegionType.data) {
      return ['Candle', 'Line'];
    } else if (selectedRegionType == PlotRegionType.indicator) {
      return ['RSI', 'MACD', 'Stochastic', 'SMA', 'EMA'];
    }
    return [];
  }

  bool _hasFixedBounds() {
    return selectedRegionType == PlotRegionType.indicator &&
        (selectedVariety == 'RSI' || 
        selectedVariety == 'Stochastic'); // Add other fixed-bound indicators as needed
  }

  void validateInputs() {
    bool isValid = false;

    if (selectedRegionType != null && selectedVariety != null) {
      // Fixed bounds indicators don't need manual min/max values
      if (_hasFixedBounds()) {
        isValid = true;
      }
      // Other indicators/regions need valid min/max values
      else if (yMinController.text.isNotEmpty &&
          yMaxController.text.isNotEmpty) {
        try {
          double yMin = double.parse(yMinController.text);
          double yMax = double.parse(yMaxController.text);
          isValid = yMax > yMin;
        } catch (e) {
          isValid = false;
        }
      }
    }

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

            // Y-Axis Min/Max inputs (shown only when variety is selected)
            if (selectedVariety != null && !_hasFixedBounds()) ...[
              const SizedBox(height: 16),
              const Text('YAxisMin'),
              TextField(
                controller: yMinController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter minimum Y value',
                ),
                onChanged: (_) => validateInputs(),
              ),
              const SizedBox(height: 16),
              const Text('YAxisMax'),
              TextField(
                controller: yMaxController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter maximum Y value',
                ),
                onChanged: (_) => validateInputs(),
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
                  double yMin, yMax;

                  // Use predefined values for indicators with fixed bounds
                  if (_hasFixedBounds()) {
                    if (selectedVariety == 'RSI') {
                      yMin = 0;
                      yMax = 100;
                    } else if (selectedVariety == 'Stochastic') {
                      yMin = 0;
                      yMax = 100;
                    } else {
                      // Default fallback
                      yMin = 0;
                      yMax = 100;
                    }
                  } else {
                    // Parse values from text fields
                    yMin = double.parse(yMinController.text);
                    yMax = double.parse(yMaxController.text);
                  }

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
