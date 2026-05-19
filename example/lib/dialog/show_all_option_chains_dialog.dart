import 'package:fin_chart/models/tasks/create_option_chain.task.dart';
import 'package:fin_chart/models/tasks/highlight_correct_option_chain_value_task.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/option_chain/models/column_config.dart';
import 'package:fin_chart/option_chain/models/option_chain_settings.dart';
import 'package:fin_chart/option_chain/models/option_leg.dart';
import 'package:fin_chart/option_chain/models/preview_data.dart';
import 'package:fin_chart/option_chain/screens/preview_screen.dart';
import 'package:flutter/material.dart';

Future<HighlightCorrectOptionChainValueTask?> showAllOptionChains({
  required BuildContext context,
  required List<Task> tasks,
}) async {
  final optionChainTasks = tasks.whereType<CreateOptionChainTask>().toList();

  if (optionChainTasks.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No option chains available')),
    );
    return null;
  }

  final selectedOptionChain = await showDialog<CreateOptionChainTask>(
    context: context,
    builder: (BuildContext dialogContext) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.92,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 12, 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Option Chain',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${optionChainTasks.length} available',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: () => Navigator.pop(dialogContext),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth < 640 ? 1 : 2;
                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: crossAxisCount == 1 ? 1.6 : 1.25,
                      ),
                      itemCount: optionChainTasks.length,
                      itemBuilder: (context, index) {
                        final task = optionChainTasks[index];
                        return Material(
                          color: Colors.white,
                          elevation: 2,
                          shadowColor: Colors.black12,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => Navigator.pop(dialogContext, task),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFE4E7EC),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFFFFFF),
                                    Color(0xFFF6F7FB),
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE9F1FF),
                                          borderRadius:
                                              BorderRadius.circular(999),
                                        ),
                                        child: Text(
                                          'Chain ${index + 1}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF2F6FED),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 18,
                                        color: Colors.black45,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'ID: ${task.optionChainId}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3F4F7),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: PreviewScreen(
                                          previewData: PreviewData(
                                            optionData: task.data,
                                            columns: task.columns,
                                            visibility: task.visibility,
                                            settings: task.settings,
                                            isEditorMode: true,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  if (selectedOptionChain == null) return null;

  final selectedRowIndex = context.mounted
      ? await showDialog<dynamic>(
          context: context,
          builder: (BuildContext dialogContext) {
            final previewKey = GlobalKey<PreviewScreenState>();

            return Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.92,
                      maxHeight: MediaQuery.of(context).size.height * 0.85,
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 12, 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Select Row',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    selectedOptionChain.optionChainId,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Close',
                              onPressed: () => Navigator.pop(dialogContext),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                        child: Text(
                          'Tap rows to select. Use Select when ready.',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F7),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE4E7EC),
                                ),
                              ),
                              child: PreviewScreen(
                                key: previewKey,
                                previewData: PreviewData(
                                    optionData: selectedOptionChain.data,
                                    columns: selectedOptionChain.columns,
                                    visibility: selectedOptionChain.visibility,
                                    settings: (selectedOptionChain.settings ??
                                        OptionChainSettings())
                                      ..isBuySellVisible = false,
                                    isEditorMode: false),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('Cancel'),
                            ),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: () {
                                final selectionMode = selectedOptionChain
                                        .settings?.selectionMode ??
                                    SelectionMode.entireRow;

                                if (selectionMode == SelectionMode.bucketRow) {
                                  final bucketRows =
                                      previewKey.currentState?.getBucketRows();
                                  if (bucketRows != null &&
                                      bucketRows.isNotEmpty) {
                                    Navigator.pop(dialogContext, bucketRows);
                                  } else {
                                    ScaffoldMessenger.of(dialogContext)
                                        .showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please select at least one row')),
                                    );
                                  }
                                } else {
                                  final selectedIndex = previewKey.currentState
                                      ?.getCorrectRowIndex();
                                  if (selectedIndex != null &&
                                      selectedIndex.isNotEmpty) {
                                    Navigator.pop(dialogContext, selectedIndex);
                                  } else {
                                    ScaffoldMessenger.of(dialogContext)
                                        .showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please select at least one row')),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.check_rounded),
                              label: const Text('Select'),
                            ),
                          ],
                        ),
                      ),
                    ])));
          },
        )
      : null;

  if (selectedRowIndex != null) {
    final selectionMode =
        selectedOptionChain.settings?.selectionMode ?? SelectionMode.entireRow;

    if (selectionMode == SelectionMode.bucketRow) {
      final bucketRows = selectedRowIndex as List<OptionLeg>;
      return HighlightCorrectOptionChainValueTask(
        optionChainId: selectedOptionChain.optionChainId,
        correctRowIndex: [],
        bucketRows: bucketRows,
      );
    } else {
      final rowIndices = selectedRowIndex as List<int>;
      return HighlightCorrectOptionChainValueTask(
        optionChainId: selectedOptionChain.optionChainId,
        correctRowIndex: rowIndices,
      );
    }
  }
  return null;
}
