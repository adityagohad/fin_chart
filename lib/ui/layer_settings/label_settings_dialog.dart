import 'package:fin_chart/models/layers/label.dart';
import 'package:fin_chart/ui/color_picker_widget.dart';
import 'package:flutter/material.dart';

class LabelSettingsDialog extends StatefulWidget {
  final Label layer;
  final Function(Label) onUpdate;

  const LabelSettingsDialog({
    super.key,
    required this.layer,
    required this.onUpdate,
  });

  @override
  State<LabelSettingsDialog> createState() => _LabelSettingsDialogState();
}

class _LabelSettingsDialogState extends State<LabelSettingsDialog> {
  late Color selectedColor;
  late double fontSize;
  late bool isBold;
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.layer.textStyle.color ?? Colors.black;
    fontSize = widget.layer.textStyle.fontSize ?? 16.0;
    isBold = widget.layer.textStyle.fontWeight == FontWeight.bold;
    textController = TextEditingController(text: widget.layer.label);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Label Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Text Color'),
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

            const Text('Label Text'),
            TextField(
              controller: textController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter label text',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Font Size'),
            Slider(
              value: fontSize,
              min: 8.0,
              max: 32.0,
              divisions: 24,
              label: fontSize.round().toString(),
              onChanged: (value) {
                setState(() {
                  fontSize = value;
                });
              },
            ),
            const SizedBox(height: 8),

            SwitchListTile(
              title: const Text('Bold Text'),
              value: isBold,
              onChanged: (value) {
                setState(() {
                  isBold = value;
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
            widget.layer.label = textController.text;
            widget.layer.textStyle = TextStyle(
              color: selectedColor,
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            );
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
    textController.dispose();
    super.dispose();
  }
}