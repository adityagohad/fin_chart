import 'package:fin_chart/models/layers/arrow.dart';
import 'package:fin_chart/ui/color_picker_widget.dart';
import 'package:flutter/material.dart';

class ArrowSettingsDialog extends StatefulWidget {
  final Arrow layer;
  final Function(Arrow) onUpdate;

  const ArrowSettingsDialog({
    super.key,
    required this.layer,
    required this.onUpdate,
  });

  @override
  State<ArrowSettingsDialog> createState() => _ArrowSettingsDialogState();
}

class _ArrowSettingsDialogState extends State<ArrowSettingsDialog> {
  late Color selectedColor;
  late double strokeWidth;
  late double arrowheadSize;
  late bool isArrowheadAtTo;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.layer.color;
    strokeWidth = widget.layer.strokeWidth;
    arrowheadSize = widget.layer.arrowheadSize;
    isArrowheadAtTo = widget.layer.isArrowheadAtTo;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Arrow Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Arrow Color'),
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

            const Text('Arrowhead Size'),
            Slider(
              value: arrowheadSize,
              min: 5.0,
              max: 30.0,
              divisions: 25,
              label: arrowheadSize.round().toString(),
              onChanged: (value) {
                setState(() {
                  arrowheadSize = value;
                });
              },
            ),
            const SizedBox(height: 16),

            SwitchListTile(
              title: Text(
                isArrowheadAtTo ? 'Arrow Direction: Forward →' : 'Arrow Direction: ← Backward',
              ),
              value: isArrowheadAtTo,
              onChanged: (value) {
                setState(() {
                  isArrowheadAtTo = value;
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
            widget.layer.strokeWidth = strokeWidth;
            widget.layer.arrowheadSize = arrowheadSize;
            widget.layer.isArrowheadAtTo = isArrowheadAtTo;
            widget.onUpdate(widget.layer);
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}