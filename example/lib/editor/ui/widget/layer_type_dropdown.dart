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
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: DropdownButton<LayerType>(
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
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(type.name),
            ),
          );
        }).toList(),
        underline: const SizedBox.shrink(),
        isExpanded: true,
        menuWidth: 250,
      ),
    );
  }
}
