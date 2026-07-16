import 'package:fin_chart/models/tasks/add_chart_tab.task.dart';
import 'package:flutter/material.dart';

Future<AddChartTabTask?> editChartTabDialog({
  required BuildContext context,
  required AddChartTabTask task,
}) async {
  final TextEditingController controller =
      TextEditingController(text: task.tabTitle);

  return showDialog<AddChartTabTask>(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Edit Chart Tab Title',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Tab Title'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      final updatedTitle = controller.text.trim();
                      if (updatedTitle.isEmpty) return;
                      Navigator.of(context).pop(
                          AddChartTabTask(tabTitle: updatedTitle));
                    },
                    child: const Text('Save'),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
