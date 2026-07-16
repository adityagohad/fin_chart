import 'dart:convert';

import 'package:fin_chart/models/tasks/add_data.task.dart';
import 'package:fin_chart/models/tasks/add_indicator.task.dart';
import 'package:fin_chart/models/tasks/add_layer.task.dart';
import 'package:fin_chart/models/tasks/add_prompt.task.dart';
import 'package:fin_chart/models/tasks/open_tool_panel.task.dart';
import 'package:fin_chart/models/tasks/show_tools.task.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/recipe.dart';
import 'package:fin_chart/models/tasks/highlight_correct_option_chain_value_task.dart';
import 'package:fin_chart/models/tasks/choose_correct_option_chain_task.dart';
import 'package:fin_chart/models/tasks/highlight_table_row_task.dart';
import 'package:fin_chart/models/tasks/show_bottom_sheet.task.dart';
import 'package:fin_chart/models/tasks/show_insights_page.task.dart';
import 'package:fin_chart/models/tasks/table_task.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/fin_chart.dart';
import 'package:fin_chart/option_chain/screens/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:fin_chart/models/tasks/add_option_chain.task.dart';
import 'package:fin_chart/models/tasks/choose_bucket_rows_task.dart';
import 'package:fin_chart/models/tasks/clear_bucket_rows_task.dart';
import 'package:example/editor/ui/widget/table_display_widget.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:fin_chart/utils/theme.dart';
import 'package:example/editor/ui/pages/sahi_widgets/sahi_top_bar.dart';
import 'package:example/editor/ui/pages/sahi_widgets/sahi_tools_bar.dart';
import 'package:example/editor/ui/pages/sahi_widgets/sahi_content_area.dart';
import 'package:example/editor/ui/pages/sahi_widgets/sahi_user_action_area.dart';

class SahiChartDemo extends StatefulWidget {
  final String recipeDataJson;

  const SahiChartDemo({super.key, required this.recipeDataJson});

  @override
  State<SahiChartDemo> createState() => _SahiChartDemoState();
}

class _SahiChartDemoState extends State<SahiChartDemo> {
  final GlobalKey<PreviewScreenState> _previewScreenKey = GlobalKey();
  Map<String, GlobalKey<PreviewScreenState>> previewScreenKeys = {};
  Map<String, GlobalKey<ChartState>> chartKeys = {};
  GlobalKey<ChartState>? _activeChartKey;
  late Recipe recipe;

  int taskPointer = 0;
  late Task currentTask;

  String promptText = "";
  String hintText = "";
  List<AddOptionChainTask> optionChainTasks = [];
  List<ShowPayOffGraphTask> payoffGraphTasks = [];
  List<Map<String, String>> tabs = [];
  int currentPageIndex = 0;
  Map<String, List<GlobalKey<TableDisplayWidgetState>>> tableWidgetKeys = {};
  Map<String, Map<int, Set<int>>> userSelectedRows = {};

  ShowToolsTask? _currentShowToolsTask;
  bool _isToolPanelOpen = false;
  OpenToolPanelTask? _currentToolPanelTask;

  String? _activeChartId;
  int _activeChartStartOffset = 0;
  int _activeChartEndOffset = -1;
  final Map<String, bool> _hasPlottedFirstChunk = {};

  @override
  void initState() {
    recipe = Recipe.fromJson(jsonDecode(widget.recipeDataJson));
    if (recipe.tasks.isNotEmpty) {
      currentTask = recipe.tasks.first;
      dd();
    }
    super.initState();
  }

  void dd() async {
    await Future.delayed(const Duration(milliseconds: 300));
    onTaskRun();
  }

  void onTaskRun() {
    switch (currentTask.taskType) {
      case TaskType.addData:
        AddDataTask task = currentTask as AddDataTask;
        final chartKey = _activeChartKey;
        if (chartKey == null) {
          onTaskFinish();
          break;
        }
        final state = chartKey.currentState;
        if (state == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onTaskRun();
          });
          break;
        }

        int from = task.fromPoint;
        int till = task.tillPoint;

        if (_activeChartId != null) {
          final isFirstChunk = _hasPlottedFirstChunk[_activeChartId!] != true;
          if (isFirstChunk) {
            from = _activeChartStartOffset;
          } else if (from < _activeChartStartOffset) {
            from = _activeChartStartOffset;
          }

          if (_activeChartEndOffset >= 0 && till > _activeChartEndOffset) {
            till = _activeChartEndOffset;
          }
        }

        from = from.clamp(0, recipe.data.length);
        till = till.clamp(from, recipe.data.length);
        if (till <= from) {
          onTaskFinish();
          break;
        }

        state
            .addDataWithAnimation(recipe.data.sublist(from, till),
                const Duration(milliseconds: 10))
            .then((_) {
          if (_activeChartId != null) {
            _hasPlottedFirstChunk[_activeChartId!] = true;
          }
          onTaskFinish();
        });
        break;
      case TaskType.addIndicator:
        AddIndicatorTask task = currentTask as AddIndicatorTask;
        final targetChartKey =
            task.chartId != null ? chartKeys[task.chartId] : _activeChartKey;
        targetChartKey?.currentState?.addIndicator(task.indicator);
        onTaskFinish();
        break;
      case TaskType.addLayer:
        AddLayerTask task = currentTask as AddLayerTask;
        _activeChartKey?.currentState
            ?.addLayerAtRegion(task.regionId, task.layer);
        onTaskFinish();
        break;
      case TaskType.addPrompt:
        AddPromptTask task = currentTask as AddPromptTask;
        setState(() {
          promptText = task.promptText;
          hintText = task.hint ?? "";
        });
        onTaskFinish();
        break;
      case TaskType.waitTask:
        setState(() {});
        break;
      case TaskType.addMcq:
        setState(() {});
        break;
      case TaskType.clearTask:
        _activeChartKey?.currentState?.clearChart();
        onTaskFinish();
        break;
      case TaskType.addOptionChain:
        AddOptionChainTask task = currentTask as AddOptionChainTask;
        optionChainTasks.add(task);
        onTaskFinish();
        break;
      case TaskType.chooseCorrectOptionChainValue:
        onTaskFinish();
        break;
      case TaskType.highlightCorrectOptionChainValue:
        HighlightCorrectOptionChainValueTask task =
            currentTask as HighlightCorrectOptionChainValueTask;
        final previewKey =
            previewScreenKeys[task.optionChainId] ?? _previewScreenKey;
        if ((task.bucketRows ?? []).isNotEmpty) {
          previewKey.currentState?.setBuySellSelections(task.bucketRows!);
        } else {
          for (int i in task.correctRowIndex) {
            previewKey.currentState?.chooseRow(i);
          }
        }
        onTaskFinish();
        break;
      case TaskType.showPayOffGraph:
        ShowPayOffGraphTask task = currentTask as ShowPayOffGraphTask;
        payoffGraphTasks.add(task);
        onTaskFinish();
        break;
      case TaskType.addTab:
        {
          final task = currentTask as AddTabTask;

          final chartTask = recipe.tasks
              .whereType<AddChartTabTask>()
              .where((t) => t.id == task.taskId)
              .toList();

          if (chartTask.isNotEmpty) {
            final existingIndex = tabs.indexWhere((tab) =>
                tab["type"] == "chart" && tab["taskId"] == task.taskId);
            if (existingIndex == -1) {
              setState(() {
                tabs.add({
                  "type": "chart",
                  "title": task.tabTitle,
                  "taskId": task.taskId,
                });
              });
            }
            _activeChartKey = chartKeys[task.taskId];
            onTaskFinish();
          } else {
            setState(() {
              previewScreenKeys[task.taskId] = GlobalKey<PreviewScreenState>();

              final optionChainTasks = recipe.tasks
                  .whereType<ChooseCorrectOptionValueChainTask>()
                  .where((t) => t.taskId == task.taskId)
                  .toList();

              if (optionChainTasks.isNotEmpty) {
                tabs.add({
                  "type": "option_chain",
                  "title": task.tabTitle,
                  "taskId": task.taskId
                });
              }

              final payoffTasks = recipe.tasks
                  .whereType<ShowPayOffGraphTask>()
                  .where((t) => t.id == task.taskId)
                  .toList();

              if (payoffTasks.isNotEmpty) {
                tabs.add({
                  "type": "payoff",
                  "title": task.tabTitle,
                  "taskId": task.taskId
                });
              }

              final insightsTasks = recipe.tasks
                  .whereType<ShowInsightsPageTask>()
                  .where((t) => t.id == task.taskId)
                  .toList();

              if (insightsTasks.isNotEmpty) {
                tabs.add({
                  "type": "insights",
                  "title": task.tabTitle,
                  "taskId": task.taskId,
                });
              }
              final tableTasks = recipe.tasks
                  .whereType<TableTask>()
                  .where((t) => t.id == task.taskId)
                  .toList();
              if (tableTasks.isNotEmpty) {
                tabs.add({
                  "type": "table",
                  "title": task.tabTitle,
                  "taskId": task.taskId,
                });
              }

              final insightsV2Tasks = recipe.tasks
                  .whereType<ShowInsightsPageV2Task>()
                  .where((t) => t.id == task.taskId)
                  .toList();

              if (insightsV2Tasks.isNotEmpty) {
                tabs.add({
                  "type": "insights_v2",
                  "title": task.tabTitle,
                  "taskId": task.taskId,
                });
              }
            });
            onTaskFinish();
          }
        }
        break;
      case TaskType.addChartTab:
        setState(() {
          final task = currentTask as AddChartTabTask;
          final chartKey = GlobalKey<ChartState>();
          chartKeys[task.id] = chartKey;
          _activeChartId = task.id;
          _activeChartStartOffset = task.fromPoint;
          _activeChartEndOffset = task.tillPoint;
          _hasPlottedFirstChunk[task.id] = false;
          _activeChartKey = chartKey;
        });
        onTaskFinish();
        break;
      case TaskType.removeTab:
        setState(() {
          final task = currentTask as RemoveTabTask;
          final removedTab = tabs.firstWhere(
            (tab) => tab["title"] == task.tabTitle,
            orElse: () => {},
          );
          if (removedTab["type"] == "chart" && removedTab["taskId"] != null) {
            chartKeys.remove(removedTab["taskId"]);
          }
          tabs.removeWhere((tab) => tab["title"] == task.tabTitle);
        });
        onTaskFinish();
        break;
      case TaskType.moveTab:
        MoveTabTask task = currentTask as MoveTabTask;
        final targetIndex = tabs.indexWhere(
          (tab) => tab["taskId"] == task.tabTaskID,
        );
        if (targetIndex == -1) {
          onTaskFinish();
          return;
        }
        final targetTab = tabs[targetIndex];
        if (targetTab["type"] == "chart") {
          final taskId = targetTab["taskId"];
          if (taskId != null && chartKeys.containsKey(taskId)) {
            _activeChartId = taskId;
            _activeChartKey = chartKeys[taskId];
            final chartTask = recipe.tasks
                .whereType<AddChartTabTask>()
                .firstWhere((t) => t.id == taskId,
                    orElse: () => AddChartTabTask(tabTitle: '', id: taskId));
            _activeChartStartOffset = chartTask.fromPoint;
            _activeChartEndOffset = chartTask.tillPoint;
          }
        }
        navigateToPage(targetIndex).then((_) {
          onTaskFinish();
        });
        break;
      case TaskType.popUpTask:
        WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((c) {
          showDialog(
              context: context,
              builder: (context) {
                ShowPopupTask task = currentTask as ShowPopupTask;
                return Dialog(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10),
                        child: MarkdownWidget(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          data: task.title,
                          config: MarkdownConfig(configs: [
                            H1Config(
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ]),
                        ),
                      ),
                      Flexible(
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: MarkdownWidget(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  data: task.description),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(task.buttonText),
                      ),
                    ],
                  ),
                );
              }).then((_) {
            onTaskFinish();
          });
        });
        setState(() {});
        break;
      case TaskType.showBottomSheet:
        WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((c) {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                ShowBottomSheetTask task = currentTask as ShowBottomSheetTask;
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MarkdownWidget(
                            data: task.title,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            config: MarkdownConfig(configs: [
                              H1Config(
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ]),
                          ),
                          const SizedBox(height: 8),
                          MarkdownWidget(
                              data: task.description,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true),
                          if (task.showImage) ...[
                            const SizedBox(height: 16),
                            Container(
                              height: 150,
                              color: Colors.grey[300],
                              child: const Center(
                                  child: Text('Image Placeholder')),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (task.secondaryButtonText != null) ...[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(task.secondaryButtonText!),
                                ),
                                const SizedBox(width: 8),
                              ],
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(task.primaryButtonText),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).then((_) {
            onTaskFinish();
          });
        });
        setState(() {});
        break;
      case TaskType.showInsightsPage:
        setState(() {});
        onTaskFinish();
        break;
      case TaskType.chooseBucketRows:
        ChooseBucketRowsTask task = currentTask as ChooseBucketRowsTask;
        final previewKey =
            previewScreenKeys[task.optionChainId] ?? _previewScreenKey;
        if (task.bucketRows != null && task.bucketRows!.isNotEmpty) {
          previewKey.currentState?.setBuySellSelections(task.bucketRows!);
        }
        onTaskFinish();
        break;
      case TaskType.clearBucketRows:
        ClearBucketRowsTask task = currentTask as ClearBucketRowsTask;
        final previewKey =
            previewScreenKeys[task.optionChainId] ?? _previewScreenKey;
        previewKey.currentState?.clearBucketSelections();
        onTaskFinish();
        break;
      case TaskType.tableTask:
        setState(() {});
        onTaskFinish();
        break;
      case TaskType.highlightTableRow:
        final task = currentTask as HighlightTableRowTask;
        final keys = tableWidgetKeys[task.tableTaskId];
        if (keys != null && task.selectedRows.isNotEmpty) {
          task.selectedRows.forEach((tableIdx, rowIndices) {
            if (tableIdx < keys.length) {
              final key = keys[tableIdx];
              key.currentState?.setSelectedRows(rowIndices.toSet());
              userSelectedRows[task.tableTaskId] ??= {};
              userSelectedRows[task.tableTaskId]![tableIdx] =
                  rowIndices.toSet();
            }
          });
        }
        setState(() {});
        onTaskFinish();
        break;
      case TaskType.showInsightsV2Page:
        setState(() {});
        onTaskFinish();
        break;
      case TaskType.showTools:
        final task = currentTask as ShowToolsTask;
        setState(() {
          _currentShowToolsTask = task;
        });
        onTaskFinish();
        break;
      case TaskType.openToolPanel:
        final task = currentTask as OpenToolPanelTask;
        setState(() {
          _isToolPanelOpen = task.open;
          _currentToolPanelTask = task;
        });
        onTaskFinish();
        break;
    }
  }

  Future<void> navigateToPage(int pageIndex) async {
    setState(() {
      currentPageIndex = pageIndex;
    });
  }

  void onTaskFinish() {
    taskPointer += 1;
    if (taskPointer < recipe.tasks.length) {
      currentTask = recipe.tasks[taskPointer];
      onTaskRun();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SahiTopBar(
              tabs: tabs,
              currentPageIndex: currentPageIndex,
              onTabTap: navigateToPage,
            ),
            Divider(height: 1, thickness: 1, color: colors.sahiDivider),
            if (_currentShowToolsTask != null)
              SahiToolsBar(
                tools: _currentShowToolsTask?.tools ?? [],
              ),
            Expanded(
              child: SahiContentArea(
                promptText: promptText,
                hintText: hintText,
                isToolPanelOpen: _isToolPanelOpen,
                enabledTools: _currentToolPanelTask?.enabledTools ?? {},
                onToolPanelClose: () {
                  setState(() {
                    _isToolPanelOpen = false;
                  });
                },
                currentPageIndex: currentPageIndex,
                tabs: tabs,
                recipe: recipe,
                chartKeys: chartKeys,
                previewScreenKey: _previewScreenKey,
                previewScreenKeys: previewScreenKeys,
                optionChainTasks: optionChainTasks,
                payoffGraphTasks: payoffGraphTasks,
                tableWidgetKeys: tableWidgetKeys,
                userSelectedRows: userSelectedRows,
                onTableSelectionChanged: (selection) {
                  setState(() {
                    selection.forEach((tableIdx, rowIndices) {
                      final taskId = tabs[currentPageIndex]["taskId"] ?? "";
                      userSelectedRows[taskId] ??= {};
                      userSelectedRows[taskId]![tableIdx] = rowIndices;
                    });
                  });
                },
              ),
            ),
            SahiUserActionArea(
              currentTask: currentTask,
              onTaskFinish: onTaskFinish,
            ),
          ],
        ),
      ),
    );
  }
}
