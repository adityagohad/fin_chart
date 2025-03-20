import 'package:example/editor/models/enums/task_type.dart';
import 'package:flutter/material.dart';

class TaskTypeDropdown extends StatelessWidget {
  final TaskType? selectedType;
  final Function(TaskType) onChanged;

  const TaskTypeDropdown({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<TaskType>(
      value: selectedType,
      onChanged: (TaskType? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
      items: TaskType.values.map<DropdownMenuItem<TaskType>>((TaskType type) {
        return DropdownMenuItem<TaskType>(
          value: type,
          child: Text(type.name),
        );
      }).toList(),
    );
  }
}
