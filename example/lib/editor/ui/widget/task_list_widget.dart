import 'package:example/editor/models/add_data.task.dart';
import 'package:example/editor/models/task.dart';
import 'package:example/editor/ui/widget/task_type_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:example/editor/models/enums/action_type.dart';
import 'package:example/editor/models/enums/task_type.dart';

class TaskListWidget extends StatefulWidget {
  final List<Task> task;
  final Function(TaskType) onTaskAdd;
  final Function(Task) onTaskClick;
  final Function(Task) onTaskEdit;
  final Function(Task) onTaskDelete;
  final Function(int, int) onTaskReorder;

  const TaskListWidget({
    super.key,
    required this.task,
    required this.onTaskAdd,
    required this.onTaskClick,
    required this.onTaskEdit,
    required this.onTaskDelete,
    required this.onTaskReorder,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 9,
          child: ReorderableListView(
            scrollDirection: Axis.horizontal,
            onReorder: widget.onTaskReorder,
            children: [
              ...widget.task.asMap().entries.map((entry) {
                Task task = entry.value;
                return InkWell(
                  key: ValueKey(task),
                  onTap: () {
                    widget.onTaskClick(task);
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
                        taskBaseOptions(task),
                        const SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            widget.onTaskDelete(task);
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
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: TaskTypeDropdown(
            selectedType: null,
            onChanged: (taskType) {
              widget.onTaskAdd(taskType);
            },
          ),
        ),
      ],
    );
  }

  Widget taskBaseOptions(Task task) {
    switch (task.taskType) {
      case TaskType.addData:
        task as AddDataTask;
        return Text("${task.fromPoint} - ${task.tillPoint}");
      case TaskType.addIndicator:
      case TaskType.addLayer:
        return Container();
      case TaskType.addPrompt:
      case TaskType.waitTask:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {
                widget.onTaskEdit(task);
              },
              child: const Icon(
                Icons.edit,
                color: Colors.blue,
                size: 18,
              ),
            ),
          ],
        );
    }
  }
}
