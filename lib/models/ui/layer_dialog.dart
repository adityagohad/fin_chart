import 'package:flutter/material.dart';

class LayerType {
  static const String indicator = 'Indicator';
  static const String drawing = 'Drawing';
  
  static List<String> values = [indicator, drawing];
}

class LayerDialog extends StatefulWidget {
  final Function(String type, String variety) onSubmit;

  const LayerDialog({super.key, required this.onSubmit});

  @override
  State<LayerDialog> createState() => _LayerDialogState();
}

class _LayerDialogState extends State<LayerDialog> {
  String? selectedLayerType;
  String? selectedVariety;
  bool inputsValid = false;

  List<String> getVarietyOptions() {
    if (selectedLayerType == LayerType.indicator) {
      return ['SMA', 'EMA','BollingerBands'];
    } else if (selectedLayerType == LayerType.drawing) {
      return ['TrendLine', 'HorizontalLine', 'RrBox'];
    }
    return [];
  }

  void validateInputs() {
    bool isValid = selectedLayerType != null && selectedVariety != null;

    if (isValid != inputsValid) {
      setState(() {
        inputsValid = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Layer'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Layer Type Dropdown
            const Text('Layer Type'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedLayerType,
              hint: const Text('Select Layer Type'),
              onChanged: (String? value) {
                setState(() {
                  selectedLayerType = value;
                  selectedVariety = null; // Reset variety when layer type changes
                });
                validateInputs();
              },
              items: LayerType.values.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Variety Dropdown (shown only when layer type is selected)
            if (selectedLayerType != null) ...[
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
                  widget.onSubmit(
                    selectedLayerType!,
                    selectedVariety!,
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