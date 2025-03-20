import 'package:example/editor/models/task.dart';
import 'package:example/widget/task_type_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:example/editor/models/enums/action_type.dart';
import 'package:example/editor/models/enums/task_type.dart';

class TaskListWidget extends StatefulWidget {
  final List<Task> task;
  final Function(TaskType) onTaskAdd;
  final Function(Task) onClick;
  final Function(Task) onDelete;
  final Function(int, int) onReorder;

  const TaskListWidget({
    super.key,
    required this.task,
    required this.onTaskAdd,
    required this.onClick,
    required this.onDelete,
    required this.onReorder,
  });

  @override
  State<TaskListWidget> createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      scrollDirection: Axis.horizontal,
      onReorder: widget.onReorder,
      children: [
        ...widget.task.asMap().entries.map((entry) {
          Task task = entry.value;
          return InkWell(
            key: ValueKey(task), // Required for ReorderableListView
            onTap: () {
              widget.onClick(task);
            },
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(12.0),
              //width: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 0.0),
                    child: Icon(
                      Icons.drag_indicator,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ),
                  Text(
                    '${task.taskType.toString().split('.').last} ${task.actionType == ActionType.interupt ? ":" : ""}',
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      widget.onDelete(task);
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        TaskTypeDropdown(
          key: const ValueKey('dropdown'),
          selectedType: null,
          onChanged: (taskType) {
            widget.onTaskAdd(taskType);
          },
        ),
      ],
    );
  }
}
