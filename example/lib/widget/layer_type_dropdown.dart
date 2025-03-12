import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:flutter/material.dart';

class LayerTypeDropdown extends StatelessWidget {
  final LayerType? selectedType;
  final Function(LayerType) onChanged;

  const LayerTypeDropdown({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<LayerType>(
      value: selectedType,
      onChanged: (LayerType? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
      items:
          LayerType.values.map<DropdownMenuItem<LayerType>>((LayerType type) {
        return DropdownMenuItem<LayerType>(
          value: type,
          child: Text(type.name),
        );
      }).toList(),
    );
  }
}
