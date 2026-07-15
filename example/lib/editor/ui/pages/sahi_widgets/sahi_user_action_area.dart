import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/models/tasks/wait.task.dart';
import 'package:fin_chart/fin_chart.dart';
import 'package:fin_chart/utils/theme.dart';
import 'package:flutter/material.dart';

class SahiUserActionArea extends StatelessWidget {
  final Task currentTask;
  final VoidCallback onTaskFinish;

  const SahiUserActionArea({
    super.key,
    required this.currentTask,
    required this.onTaskFinish,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    switch (currentTask.taskType) {
      case TaskType.addData:
      case TaskType.addIndicator:
      case TaskType.addLayer:
      case TaskType.addPrompt:
      case TaskType.clearTask:
        return const SizedBox.shrink();
      case TaskType.addMcq:
        final task = currentTask as AddMcqTask;
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: colors.sahiDivider, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: task.options.map((e) {
              return ElevatedButton(
                  onPressed: onTaskFinish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.sahiTabActiveBg,
                    foregroundColor: colors.sahiTabActiveText,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(e));
            }).toList(),
          ),
        );
      case TaskType.waitTask:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: colors.sahiDivider, width: 1),
            ),
          ),
          child: Center(
            child: ElevatedButton(
                onPressed: onTaskFinish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.sahiTabActiveBg,
                  foregroundColor: colors.sahiTabActiveText,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text((currentTask as WaitTask).btnText)),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
