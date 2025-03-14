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

  @override
  void initState() {
    super.initState();
    selectedColor = widget.layer.color;
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
            widget.onUpdate(widget.layer);
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}