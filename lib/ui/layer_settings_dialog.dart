import 'package:fin_chart/models/layers/arrow.dart';
import 'package:fin_chart/models/layers/circular_area.dart';
import 'package:fin_chart/models/layers/horizontal_band.dart';
import 'package:fin_chart/models/layers/horizontal_line.dart';
import 'package:fin_chart/models/layers/label.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/models/layers/rect_area.dart';
import 'package:fin_chart/models/layers/trend_line.dart';
import 'package:fin_chart/ui/layer_settings/arrow_settings_dialog.dart';
import 'package:fin_chart/ui/layer_settings/circular_area_settings_dialog.dart';
import 'package:fin_chart/ui/layer_settings/horizontal_band_settings_dialog.dart';
import 'package:fin_chart/ui/layer_settings/horizontal_line_settings_dialog.dart';
import 'package:fin_chart/ui/layer_settings/label_settings_dialog.dart';
import 'package:fin_chart/ui/layer_settings/rect_area_settings_dialog.dart';
import 'package:fin_chart/ui/layer_settings/trend_line_settings_dialog.dart';
import 'package:flutter/material.dart';

/// Shows the appropriate settings dialog for the selected layer type
void showLayerSettingsDialog(
    BuildContext context, Layer selectedLayer, Function(Layer) onUpdate) {
  Widget dialogWidget;

  if (selectedLayer is TrendLine) {
    dialogWidget = TrendLineSettingsDialog(
      layer: selectedLayer,
      onUpdate: onUpdate,
    );
  } else if (selectedLayer is HorizontalLine) {
    dialogWidget = HorizontalLineSettingsDialog(
      layer: selectedLayer,
      onUpdate: onUpdate,
    );
  } else if (selectedLayer is HorizontalBand) {
    dialogWidget = HorizontalBandSettingsDialog(
      layer: selectedLayer,
      onUpdate: onUpdate,
    );
  } else if (selectedLayer is CircularArea) {
    dialogWidget = CircularAreaSettingsDialog(
      layer: selectedLayer,
      onUpdate: onUpdate,
    );
  } else if (selectedLayer is RectArea) {
    dialogWidget = RectAreaSettingsDialog(
      layer: selectedLayer,
      onUpdate: onUpdate,
    );
  } else if (selectedLayer is Label) {
    dialogWidget = LabelSettingsDialog(
      layer: selectedLayer,
      onUpdate: onUpdate,
    );
  } else if (selectedLayer is Arrow) {
    dialogWidget = ArrowSettingsDialog(
      layer: selectedLayer,
      onUpdate: onUpdate,
    );
  } else {
    // Generic dialog for unknown layer types
    dialogWidget = AlertDialog(
      title: const Text('Layer Settings'),
      content: const Text('Settings not available for this layer type.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  showDialog(
    context: context,
    builder: (context) => dialogWidget,
  );
}