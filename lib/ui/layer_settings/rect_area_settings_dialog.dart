import 'package:fin_chart/models/layers/rect_area.dart';
import 'package:fin_chart/ui/color_picker_widget.dart';
import 'package:flutter/material.dart';

class RectAreaSettingsDialog extends StatefulWidget {
  final RectArea layer;
  final Function(RectArea) onUpdate;

  const RectAreaSettingsDialog({
    super.key,
    required this.layer,
    required this.onUpdate,
  });

  @override
  State<RectAreaSettingsDialog> createState() => _RectAreaSettingsDialogState();
}

class _RectAreaSettingsDialogState extends State<RectAreaSettingsDialog> {
  late Color selectedColor;
  late double strokeWidth;
  late int alpha;
  late double endPointRadius;
  late bool isLocked;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.layer.color;
    strokeWidth = widget.layer.strokeWidth;
    alpha = widget.layer.alpha;
    endPointRadius = widget.layer.endPointRadius;
    isLocked = widget.layer.isLocked;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rectangle Area Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rectangle Color'),
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
            const Text('Opacity'),
            Slider(
              value: alpha.toDouble(),
              min: 0,
              max: 255,
              divisions: 255,
              label: alpha.toString(),
              onChanged: (value) {
                setState(() {
                  alpha = value.toInt();
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Stroke Width'),
            Slider(
              value: strokeWidth,
              min: 1,
              max: 10,
              divisions: 9,
              label: strokeWidth.toString(),
              onChanged: (value) {
                setState(() {
                  strokeWidth = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Handle Radius'),
            Slider(
              value: endPointRadius,
              min: 3,
              max: 15,
              divisions: 12,
              label: endPointRadius.toString(),
              onChanged: (value) {
                setState(() {
                  endPointRadius = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: isLocked,
                  onChanged: (value) {
                    setState(() {
                      isLocked = value ?? false;
                    });
                  },
                ),
                const Text('Lock Rectangle'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Rectangle Position',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Top Left: (${widget.layer.topLeft.dx.toStringAsFixed(2)}, ${widget.layer.topLeft.dy.toStringAsFixed(2)})',
            ),
            Text(
              'Bottom Right: (${widget.layer.bottomRight.dx.toStringAsFixed(2)}, ${widget.layer.bottomRight.dy.toStringAsFixed(2)})',
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
            widget.layer.alpha = alpha;
            widget.layer.endPointRadius = endPointRadius;
            widget.layer.isLocked = isLocked;
            widget.onUpdate(widget.layer);
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
