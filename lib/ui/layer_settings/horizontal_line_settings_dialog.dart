import 'package:fin_chart/models/layers/horizontal_line.dart';
import 'package:fin_chart/ui/color_picker_widget.dart';
import 'package:flutter/material.dart';

class HorizontalLineSettingsDialog extends StatefulWidget {
  final HorizontalLine layer;
  final Function(HorizontalLine) onUpdate;

  const HorizontalLineSettingsDialog({
    super.key,
    required this.layer,
    required this.onUpdate,
  });

  @override
  State<HorizontalLineSettingsDialog> createState() => _HorizontalLineSettingsDialogState();
}

class _HorizontalLineSettingsDialogState extends State<HorizontalLineSettingsDialog> {
  late Color selectedColor;
  late double strokeWidth;
  late TextEditingController valueController;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.layer.color;
    strokeWidth = widget.layer.strokeWidth;
    valueController = TextEditingController(text: widget.layer.value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Horizontal Line Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Line Color'),
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

            const Text('Line Thickness'),
            Slider(
              value: strokeWidth,
              min: 1.0,
              max: 10.0,
              divisions: 9,
              label: strokeWidth.round().toString(),
              onChanged: (value) {
                setState(() {
                  strokeWidth = value;
                });
              },
            ),
            const SizedBox(height: 16),

            const Text('Value'),
            TextField(
              controller: valueController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter line value',
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
            widget.layer.strokeWidth = strokeWidth;
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