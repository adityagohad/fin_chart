import 'package:fin_chart/models/enums/task_type.dart';
import 'package:flutter/material.dart';

class TaskTypeDropdown extends StatelessWidget {
  final TaskType? selectedType;
  final Function(TaskType) onChanged;
  final Set<TaskType> disabledTypes;

  const TaskTypeDropdown({
    super.key,
    required this.selectedType,
    required this.onChanged,
    this.disabledTypes = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: DropdownButton<TaskType>(
        value: selectedType,
        onChanged: (TaskType? newValue) {
          if (newValue != null && !disabledTypes.contains(newValue)) {
            onChanged(newValue);
          }
        },
        items: TaskType.values.map<DropdownMenuItem<TaskType>>((TaskType type) {
          final isDisabled = disabledTypes.contains(type);
          return DropdownMenuItem<TaskType>(
            value: isDisabled ? null : type,
            enabled: !isDisabled,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: isDisabled ? Colors.grey.shade300 : Colors.black),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                type.name,
                style: TextStyle(
                  color: isDisabled ? Colors.grey.shade400 : Colors.black,
                ),
              ),
            ),
          );
        }).toList(),
        underline: const SizedBox.shrink(),
        isExpanded: true,
        menuWidth: 300,
      ),
    );
  }
}
