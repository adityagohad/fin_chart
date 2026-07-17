import 'package:fin_chart/models/tasks/add_chart_tab.task.dart';
import 'package:flutter/material.dart';

Future<AddChartTabTask?> addChartTabDialog({
  required BuildContext context,
}) async {
  String tabTitle = '';

  return showDialog<AddChartTabTask>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.4,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Add Chart',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) => tabTitle = value,
                    decoration: const InputDecoration(
                        hintText: 'Chart Title',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (tabTitle.trim().isEmpty) return;
                          Navigator.of(context).pop(AddChartTabTask(
                            tabTitle: tabTitle,
                          ));
                        },
                        child: const Text('Create'),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
