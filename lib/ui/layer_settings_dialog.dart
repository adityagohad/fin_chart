import 'package:fin_chart/models/layers/arrow.dart';
import 'package:fin_chart/models/layers/circular_area.dart';
import 'package:fin_chart/models/layers/horizontal_band.dart';
import 'package:fin_chart/models/layers/horizontal_line.dart';
import 'package:fin_chart/models/layers/label.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/models/layers/rect_area.dart';
import 'package:fin_chart/models/layers/trend_line.dart';
import 'package:flutter/material.dart';

class LayerSettingsDialog extends StatefulWidget {
  final Layer selectedLayer;
  final Function(Layer) onUpdate;

  const LayerSettingsDialog({
    super.key,
    required this.selectedLayer,
    required this.onUpdate,
  });

  @override
  State<LayerSettingsDialog> createState() => _LayerSettingsDialogState();
}

class _LayerSettingsDialogState extends State<LayerSettingsDialog> {
  late Layer currentLayer;
  late Color selectedColor;
  late double strokeWidth;
  late TextEditingController textController;
  late double fontSize;
  late bool isBold;

  @override
  void initState() {
    super.initState();
    currentLayer = widget.selectedLayer;

    // Initialize based on layer type
    if (currentLayer is TrendLine) {
      final layer = currentLayer as TrendLine;
      selectedColor = layer.color;
      strokeWidth = layer.strokeWidth;
    } else if (currentLayer is HorizontalLine) {
      final layer = currentLayer as HorizontalLine;
      selectedColor = layer.color;
      strokeWidth = layer.strokeWidth;
    } else if (currentLayer is HorizontalBand) {
      final layer = currentLayer as HorizontalBand;
      selectedColor = layer.color;
    } else if (currentLayer is CircularArea) {
      final layer = currentLayer as CircularArea;
      selectedColor = layer.color;
      strokeWidth = layer.radius; // Using strokeWidth for radius
    } else if (currentLayer is RectArea) {
      final layer = currentLayer as RectArea;
      selectedColor = layer.color;
    } else if (currentLayer is Label) {
      final layer = currentLayer as Label;
      selectedColor = layer.textStyle.color ?? Colors.black;
      fontSize = layer.textStyle.fontSize ?? 16.0;
      isBold = layer.textStyle.fontWeight == FontWeight.bold;
      textController = TextEditingController(text: layer.label);
    } else if (currentLayer is Arrow) {
      final layer = currentLayer as Arrow;
      selectedColor = layer.color;
      strokeWidth = layer.strokeWidth;
    } else {
      // Default values
      selectedColor = Colors.black;
      strokeWidth = 2.0;
    }

    // Initialize for text if not already
    if (!_isLabelLayer()) {
      textController = TextEditingController();
      fontSize = 16.0;
      isBold = false;
    }
  }

  bool _isLabelLayer() {
    return currentLayer is Label;
  }

  bool _hasStrokeWidth() {
    return currentLayer is TrendLine ||
        currentLayer is HorizontalLine ||
        currentLayer is Arrow;
  }

  bool _hasRadius() {
    return currentLayer is CircularArea;
  }

  bool _hasAllowedError() {
    return currentLayer is HorizontalBand;
  }

  bool _hasArrowheadOption() {
    return currentLayer is Arrow;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Layer Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color picker
            const Text('Color'),
            const SizedBox(height: 8),
            _buildColorPicker(),
            const SizedBox(height: 16),

            // Stroke width or radius
            if (_hasStrokeWidth() || _hasRadius())
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_hasRadius() ? 'Radius' : 'Stroke Width'),
                  Slider(
                    value: strokeWidth,
                    min: 1.0,
                    max: _hasRadius() ? 50.0 : 10.0,
                    divisions: _hasRadius() ? 49 : 9,
                    label: strokeWidth.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        strokeWidth = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            // Allowed error for horizontal band
            if (_hasAllowedError())
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Band Width'),
                  Slider(
                    value: (currentLayer as HorizontalBand).allowedError,
                    min: 10.0,
                    max: 200.0,
                    divisions: 19,
                    label: (currentLayer as HorizontalBand)
                        .allowedError
                        .round()
                        .toString(),
                    onChanged: (value) {
                      setState(() {
                        (currentLayer as HorizontalBand).allowedError = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            // Arrow direction toggle
            if (_hasArrowheadOption())
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Arrow Direction'),
                  SwitchListTile(
                    title: Text(
                      (currentLayer as Arrow).isArrowheadAtTo
                          ? 'Forward →'
                          : '← Backward',
                    ),
                    value: (currentLayer as Arrow).isArrowheadAtTo,
                    onChanged: (value) {
                      setState(() {
                        (currentLayer as Arrow).isArrowheadAtTo = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            // Text options for Label
            if (_isLabelLayer())
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  SwitchListTile(
                    title: const Text('Bold'),
                    value: isBold,
                    onChanged: (value) {
                      setState(() {
                        isBold = value;
                      });
                    },
                  ),
                ],
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
            _updateLayer();
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildColorPicker() {
    final List<Color> colors = [
      Colors.black,
      Colors.red,
      Colors.orange,
      Colors.amber,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.pink,
      Colors.teal,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors.map((color) {
        final isSelected = selectedColor.value == color.value;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedColor = color;
            });
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 4,
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _updateLayer() {
    if (currentLayer is TrendLine) {
      final layer = currentLayer as TrendLine;
      layer.color = selectedColor;
      layer.strokeWidth = strokeWidth;
    } else if (currentLayer is HorizontalLine) {
      final layer = currentLayer as HorizontalLine;
      layer.color = selectedColor;
      layer.strokeWidth = strokeWidth;
    } else if (currentLayer is HorizontalBand) {
      final layer = currentLayer as HorizontalBand;
      layer.color = selectedColor;
      // Allowed error already updated in slider
    } else if (currentLayer is CircularArea) {
      final layer = currentLayer as CircularArea;
      layer.color = selectedColor;
      layer.radius = strokeWidth; // Using strokeWidth for radius
    } else if (currentLayer is RectArea) {
      final layer = currentLayer as RectArea;
      layer.color = selectedColor;
    } else if (currentLayer is Label) {
      final layer = currentLayer as Label;
      layer.label = textController.text;
      layer.textStyle = TextStyle(
        color: selectedColor,
        fontSize: fontSize,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      );
    } else if (currentLayer is Arrow) {
      final layer = currentLayer as Arrow;
      layer.color = selectedColor;
      layer.strokeWidth = strokeWidth;
      // isArrowheadAtTo already updated in switch
    }

    widget.onUpdate(currentLayer);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}