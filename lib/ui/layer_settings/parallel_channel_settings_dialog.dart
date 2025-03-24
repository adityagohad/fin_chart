import 'package:fin_chart/models/layers/parallel_channel.dart';
import 'package:fin_chart/ui/color_picker_widget.dart';
import 'package:flutter/material.dart';

class ParallelChannelSettingsDialog extends StatefulWidget {
  final ParallelChannel layer;
  final Function(ParallelChannel) onUpdate;

  const ParallelChannelSettingsDialog({
    super.key,
    required this.layer,
    required this.onUpdate,
  });

  @override
  State<ParallelChannelSettingsDialog> createState() =>
      _ParallelChannelSettingsDialogState();
}

class _ParallelChannelSettingsDialogState
    extends State<ParallelChannelSettingsDialog> {
  late Color selectedColor;
  late double strokeWidth;
  late int channelAlpha;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.layer.color;
    strokeWidth = widget.layer.strokeWidth;
    channelAlpha = widget.layer.channelAlpha;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Parallel Channel Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Channel Color'),
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
            const Text('Channel Opacity'),
            Slider(
              value: channelAlpha.toDouble(),
              min: 0,
              max: 255,
              divisions: 256,
              label: '$channelAlpha%',
              onChanged: (value) {
                setState(() {
                  channelAlpha = value.round();
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
            widget.layer.channelAlpha = channelAlpha;
            widget.onUpdate(widget.layer);
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
