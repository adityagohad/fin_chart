import 'package:fin_chart/models/layers/horizontal_band.dart';
import 'package:fin_chart/ui/color_picker_widget.dart';
import 'package:flutter/material.dart';

class HorizontalBandSettingsDialog extends StatefulWidget {
  final HorizontalBand layer;
  final Function(HorizontalBand) onUpdate;

  const HorizontalBandSettingsDialog({
    super.key,
    required this.layer,
    required this.onUpdate,
  });

  @override
  State<HorizontalBandSettingsDialog> createState() => _HorizontalBandSettingsDialogState();
}

class _HorizontalBandSettingsDialogState extends State<HorizontalBandSettingsDialog> {
  late Color selectedColor;
  late double allowedError;
  late TextEditingController valueController;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.layer.color;
    allowedError = widget.layer.allowedError;
    valueController = TextEditingController(text: widget.layer.value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Horizontal Band Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Band Color'),
            const SizedBox(height: 8),
            ColorPickerWidget(
              selectedColor: selectedColor,
              onColorSelected: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
            ),
            const SizedBox(height: 16),

            const Text('Band Width'),
            Slider(
              value: allowedError,
              min: 10.0,
              max: 200.0,
              divisions: 19,
              label: allowedError.round().toString(),
              onChanged: (value) {
                setState(() {
                  allowedError = value;
                });
              },
            ),
            const SizedBox(height: 16),

            const Text('Center Value'),
            TextField(
              controller: valueController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter center value',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.layer.color = selectedColor;
            widget.layer.allowedError = allowedError;
            try {
              widget.layer.value = double.parse(valueController.text);
            } catch (e) {
              // Handle parsing error
            }
            widget.onUpdate(widget.layer);
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    valueController.dispose();
    super.dispose();
  }
}