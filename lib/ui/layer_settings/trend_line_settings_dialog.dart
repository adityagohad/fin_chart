import 'package:fin_chart/models/layers/trend_line.dart';
import 'package:fin_chart/ui/color_picker_widget.dart';
import 'package:flutter/material.dart';

class TrendLineSettingsDialog extends StatefulWidget {
  final TrendLine layer;
  final Function(TrendLine) onUpdate;

  const TrendLineSettingsDialog({
    super.key,
    required this.layer,
    required this.onUpdate,
  });

  @override
  State<TrendLineSettingsDialog> createState() => _TrendLineSettingsDialogState();
}

class _TrendLineSettingsDialogState extends State<TrendLineSettingsDialog> {
  late Color selectedColor;
  late double strokeWidth;
  late double endPointRadius;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.layer.color;
    strokeWidth = widget.layer.strokeWidth;
    endPointRadius = widget.layer.endPointRadius;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Trend Line Settings'),
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

            const Text('Endpoint Size'),
            Slider(
              value: endPointRadius,
              min: 2.0,
              max: 15.0,
              divisions: 13,
              label: endPointRadius.round().toString(),
              onChanged: (value) {
                setState(() {
                  endPointRadius = value;
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
            widget.layer.endPointRadius = endPointRadius;
            widget.onUpdate(widget.layer);
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}