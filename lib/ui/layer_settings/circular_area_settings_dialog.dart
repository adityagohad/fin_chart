import 'package:fin_chart/models/layers/circular_area.dart';
import 'package:fin_chart/ui/color_picker_widget.dart';
import 'package:flutter/material.dart';

class CircularAreaSettingsDialog extends StatefulWidget {
  final CircularArea layer;
  final Function(CircularArea) onUpdate;

  const CircularAreaSettingsDialog({
    super.key,
    required this.layer,
    required this.onUpdate,
  });

  @override
  State<CircularAreaSettingsDialog> createState() => _CircularAreaSettingsDialogState();
}

class _CircularAreaSettingsDialogState extends State<CircularAreaSettingsDialog> {
  late Color selectedColor;
  late double radius;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.layer.color;
    radius = widget.layer.radius;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Circular Area Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Circle Color'),
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

            const Text('Circle Radius'),
            Slider(
              value: radius,
              min: 5.0,
              max: 50.0,
              divisions: 9,
              label: radius.round().toString(),
              onChanged: (value) {
                setState(() {
                  radius = value;
                });
              },
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
            widget.layer.radius = radius;
            widget.onUpdate(widget.layer);
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}