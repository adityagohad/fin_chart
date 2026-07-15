import 'dart:convert';

import 'package:fin_chart/models/tasks/add_data.task.dart';
import 'package:fin_chart/models/tasks/add_indicator.task.dart';
import 'package:fin_chart/models/tasks/add_layer.task.dart';
import 'package:fin_chart/models/tasks/add_prompt.task.dart';
import 'package:fin_chart/models/tasks/open_tool_panel.task.dart';
import 'package:fin_chart/models/tasks/show_tools.task.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:fin_chart/models/recipe.dart';
import 'package:fin_chart/models/tasks/highlight_correct_option_chain_value_task.dart';
import 'package:fin_chart/models/tasks/choose_correct_option_chain_task.dart';
import 'package:fin_chart/models/tasks/highlight_table_row_task.dart';
import 'package:fin_chart/models/tasks/show_bottom_sheet.task.dart';
import 'package:fin_chart/models/tasks/show_insights_page.task.dart';
import 'package:fin_chart/models/tasks/table_task.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/models/tasks/wait.task.dart';
import 'package:fin_chart/fin_chart.dart';
import 'package:fin_chart/option_chain/screens/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:fin_chart/models/tasks/add_option_chain.task.dart';
import 'package:fin_chart/models/tasks/choose_bucket_rows_task.dart';
import 'package:fin_chart/models/tasks/clear_bucket_rows_task.dart';
import 'package:example/editor/ui/widget/table_display_widget.dart';
import 'package:markdown_widget/markdown_widget.dart';

class ChartDemo extends StatefulWidget {
  final String recipeDataJson;

  const ChartDemo({super.key, required this.recipeDataJson});

  @override
  State<ChartDemo> createState() => _ChartDemoState();
}

class _ChartDemoState extends State<ChartDemo> {
  final GlobalKey<ChartState> _chartKey = GlobalKey();
  final GlobalKey<PreviewScreenState> _previewScreenKey = GlobalKey();
  Map<String, GlobalKey<PreviewScreenState>> previewScreenKeys = {};
  late Recipe recipe;

  int taskPointer = 0;
  late Task currentTask;

  String promptText = "";
  String hintText = "";
  Widget? chart;
  PageController controller = PageController();
  List<AddOptionChainTask> optionChainTasks = [];
  List<ShowPayOffGraphTask> payoffGraphTasks = [];
  List<Map<String, String>> tabs = [];
  int currentPageIndex = 0;
  Map<String, List<GlobalKey<TableDisplayWidgetState>>> tableWidgetKeys = {};
  Map<String, Map<int, Set<int>>> userSelectedRows = {};

  ShowToolsTask? _currentShowToolsTask;
  bool _isToolPanelOpen = false;
  OpenToolPanelTask? _currentToolPanelTask;

  @override
  void initState() {
    recipe = Recipe.fromJson(jsonDecode(widget.recipeDataJson));
    if (recipe.tasks.isNotEmpty) {
      currentTask = recipe.tasks.first;
      dd();
    }
    tabs.add({"type": "chart", "title": "Chart"});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chart = Chart.from(
        key: _chartKey,
        recipe: recipe,
        onInteraction: (p0, p1) {},
        theme: Theme.of(context));
  }

  void dd() async {
    await Future.delayed(const Duration(milliseconds: 300));
    onTaskRun();
  }

  void onTaskRun() {
    switch (currentTask.taskType) {
      case TaskType.addData:
        AddDataTask task = currentTask as AddDataTask;
        _chartKey.currentState
            ?.addDataWithAnimation(
                recipe.data.sublist(task.fromPoint, task.tillPoint),
                const Duration(milliseconds: 10))
            .then((value) {
          if (value) {
            onTaskFinish();
          }
        });
        break;
      case TaskType.addIndicator:
        AddIndicatorTask task = currentTask as AddIndicatorTask;
        _chartKey.currentState?.addIndicator(task.indicator);
        onTaskFinish();
        break;
      case TaskType.addLayer:
        AddLayerTask task = currentTask as AddLayerTask;
        _chartKey.currentState?.addLayerAtRegion(task.regionId, task.layer);
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
        _chartKey.currentState?.clearChart();
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
        setState(() {
          final task = currentTask as AddTabTask;
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
        break;
      case TaskType.removeTab:
        setState(() {
          final task = currentTask as RemoveTabTask;
          tabs.removeWhere((tab) => tab["title"] == task.tabTitle);
        });
        onTaskFinish();
        break;
      case TaskType.moveTab:
        MoveTabTask task = currentTask as MoveTabTask;
        if (task.tabTaskID == "chart") {
          navigateToPage(0).then((_) {
            onTaskFinish();
          });
          return;
        }
        final addTabTasks = recipe.tasks.whereType<AddTabTask>().toList();
        if (addTabTasks.isEmpty) {
          onTaskFinish();
          return;
        }
        final targetTabTask =
            addTabTasks.firstWhere((t) => t.taskId == task.tabTaskID);
        final targetTab = tabs.firstWhere(
          (tab) => tab["title"] == targetTabTask.tabTitle,
          orElse: () => tabs.first,
        );
        final targetTabIndex = tabs.indexOf(targetTab);

        navigateToPage(targetTabIndex).then((_) {
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
                  // title: Text(task.title),
                  // content: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: SizedBox(
                  //       height: 200,
                  //       width: 200,
                  //       child: MarkdownWidget(
                  //         data: task.description,
                  //         shrinkWrap: true,
                  //         physics: NeverScrollableScrollPhysics(),
                  //       ),
                  //     )),
                  // actions: [
                  //   TextButton(
                  //     onPressed: () {
                  //       Navigator.of(context).pop();
                  //     },
                  //     child: Text(task.buttonText),
                  //   ),
                  // ],
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
    await controller.animateToPage(
      pageIndex,
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
    );
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Finance Charts Demo"),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            flex: 2,
            child: FittedBox(
              fit: BoxFit.none,
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    MarkdownWidget(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        data: promptText),
                    hintText.isNotEmpty ? Text(hintText) : Container()
                  ],
                ),
              ),
            ),
          ),
          Text(tabs.toString()),
          Expanded(
            flex: 6,
            child: Row(
              children: [
                if (_isToolPanelOpen) _buildToolsPanel(),
                Expanded(
                  child: Stack(
                    children: [
                      PageView.builder(
                          controller: controller,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tabs.length,
                          itemBuilder: (context, index) {
                            final tab = tabs[index];
                            switch (tab["type"]) {
                              case "chart":
                                return Chart.from(
                                    key: _chartKey,
                                    recipe: recipe,
                                    onInteraction: (p0, p1) {},
                                    theme: Theme.of(context));
                              case "option_chain":
                                final taskId = tab["taskId"]!;
                                final chooseTask = recipe.tasks
                                    .whereType<
                                        ChooseCorrectOptionValueChainTask>()
                                    .firstWhere((t) => t.taskId == taskId);

                                final optionChainTask =
                                    optionChainTasks.firstWhere(
                                  (t) =>
                                      t.optionChainId == chooseTask.taskId,
                                  orElse: () => optionChainTasks.first,
                                );

                                return PreviewScreen.from(
                                    key: previewScreenKeys[taskId] ??
                                        _previewScreenKey,
                                    task: optionChainTask,
                                    isEditorMode: false,
                                    maxSelectableRows:
                                        chooseTask.maxSelectableRows);
                              case "payoff":
                                final taskId = tab["taskId"]!;
                                final payoffTask = payoffGraphTasks.firstWhere(
                                  (t) => t.id == taskId,
                                  orElse: () => payoffGraphTasks.first,
                                );
                                return Container(
                                  color: Colors.blue,
                                  child: Center(
                                    child: Text(
                                        "Payoff Graph View for ${payoffTask.id}"),
                                  ),
                                );
                              case "insights":
                                final taskId = tab["taskId"]!;
                                final insightsTask = recipe.tasks
                                    .whereType<ShowInsightsPageTask>()
                                    .firstWhere((t) => t.id == taskId);
                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MarkdownWidget(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        data: insightsTask.title,
                                        config: MarkdownConfig(configs: [
                                          H1Config(
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight:
                                                      FontWeight.bold)),
                                        ]),
                                      ),
                                      const SizedBox(height: 16),
                                      MarkdownWidget(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          data: insightsTask.description),
                                    ],
                                  ),
                                );
                              case "table":
                                final taskId = tab["taskId"]!;
                                final tableTask = recipe.tasks
                                    .whereType<TableTask>()
                                    .firstWhere((t) => t.id == taskId);
                                if (!tableWidgetKeys
                                    .containsKey(taskId)) {
                                  tableWidgetKeys[taskId] = List.generate(
                                    tableTask.tables.tables.length,
                                    (_) =>
                                        GlobalKey<TableDisplayWidgetState>(),
                                  );
                                }
                                return SingleChildScrollView(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...tableTask.tables.tables
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        final idx = entry.key;
                                        final table = entry.value;
                                        final selectedRows =
                                            userSelectedRows[taskId]
                                                    ?[idx] ??
                                                <int>{};
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 24),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                table.tableTitle,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                              ),
                                              if (table.tableDescription
                                                  .isNotEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: Text(
                                                    table.tableDescription,
                                                    style:
                                                        Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium,
                                                  ),
                                                ),
                                              TableDisplayWidget(
                                                key: tableWidgetKeys[
                                                    taskId]![idx],
                                                columns: table.columns,
                                                rows: table.rows,
                                                selectedRowIndices:
                                                    selectedRows,
                                                onRowTap: (rowIdx) {
                                                  setState(() {
                                                    userSelectedRows[
                                                            taskId] ??= {};
                                                    final selected =
                                                        userSelectedRows[
                                                                    taskId]![
                                                                idx] ??
                                                            <int>{};
                                                    if (selected
                                                        .contains(
                                                            rowIdx)) {
                                                      selected.remove(
                                                          rowIdx);
                                                    } else {
                                                      selected.add(
                                                          rowIdx);
                                                    }
                                                    userSelectedRows[
                                                            taskId]![idx] =
                                                        selected;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                );
                              case "insights_v2":
                                final taskId = tab["taskId"]!;
                                final insightsTask = recipe.tasks
                                    .whereType<ShowInsightsPageV2Task>()
                                    .firstWhere((t) => t.id == taskId);
                                return InsightsPreviewPage(
                                    task: insightsTask);
                              default:
                                return Container();
                            }
                          }),
                      if (_currentShowToolsTask != null)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Material(
                            color: Colors.black54,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () {
                                setState(() {
                                  _isToolPanelOpen = !_isToolPanelOpen;
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.build,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: FittedBox(fit: BoxFit.none, child: userActionContainer()))
        ],
      )),
    );
  }

  Widget _buildToolsPanel() {
    final enabledTools = _currentToolPanelTask?.enabledTools ?? {};
    bool isEnabled(String name) => enabledTools[name] ?? true;

    final indicators = IndicatorType.values;
    final layers = LayerType.values;

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(
          right: BorderSide(color: Colors.grey[700]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              border: Border(
                bottom: BorderSide(color: Colors.grey[700]!),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tools',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isToolPanelOpen = false;
                    });
                  },
                  child: const Icon(Icons.close,
                      color: Colors.white70, size: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 4),
              children: [
                _buildSectionHeader('Indicators'),
                ...indicators.map((indicator) {
                  final enabled = isEnabled(indicator.name);
                  return _buildToolItem(
                    _indicatorIcon(indicator),
                    indicator.name,
                    enabled: enabled,
                  );
                }),
                const SizedBox(height: 8),
                _buildSectionHeader('Drawing Tools'),
                ...layers.map((layer) {
                  final enabled = isEnabled(layer.name);
                  return _buildToolItem(
                    _layerIcon(layer),
                    layer.name,
                    enabled: enabled,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildToolItem(IconData icon, String label, {bool enabled = true}) {
    return InkWell(
      onTap: enabled ? () {} : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.35,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon,
                  color: enabled ? Colors.white70 : Colors.white38, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: enabled ? Colors.white70 : Colors.white38,
                    fontSize: 13,
                  ),
                ),
              ),
              if (!enabled)
                const Icon(Icons.lock_outline,
                    color: Colors.white24, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  IconData _indicatorIcon(IndicatorType type) {
    switch (type) {
      case IndicatorType.rsi:
        return Icons.speed;
      case IndicatorType.macd:
        return Icons.candlestick_chart;
      case IndicatorType.sma:
      case IndicatorType.ema:
        return Icons.auto_graph;
      case IndicatorType.bollingerBand:
        return Icons.straighten;
      case IndicatorType.stochastic:
        return Icons.show_chart;
      case IndicatorType.mfi:
        return Icons.account_balance_wallet;
      case IndicatorType.adx:
        return Icons.trending_up;
      case IndicatorType.atr:
        return Icons.gesture;
      case IndicatorType.pivotPoint:
        return Icons.horizontal_rule;
      case IndicatorType.pe:
      case IndicatorType.pb:
        return Icons.attach_money;
      case IndicatorType.supertrend:
        return Icons.alt_route;
      case IndicatorType.vwap:
        return Icons.functions;
      case IndicatorType.evEbitda:
      case IndicatorType.evSales:
        return Icons.analytics;
      case IndicatorType.scanner:
        return Icons.radar;
      case IndicatorType.roc:
        return Icons.timeline;
    }
  }

  IconData _layerIcon(LayerType type) {
    switch (type) {
      case LayerType.label:
        return Icons.text_fields;
      case LayerType.horizontalLine:
        return Icons.horizontal_rule;
      case LayerType.horizontalBand:
        return Icons.straighten;
      case LayerType.trendLine:
        return Icons.show_chart;
      case LayerType.parallelChannel:
        return Icons.timeline;
      case LayerType.rectArea:
        return Icons.crop_square;
      case LayerType.circularArea:
        return Icons.circle_outlined;
      case LayerType.arrow:
        return Icons.arrow_right_alt;
      case LayerType.arrowTextPointer:
        return Icons.location_on;
      case LayerType.verticalLine:
        return Icons.format_size;
    }
  }

  Widget userActionContainer() {
    switch (currentTask.taskType) {
      case TaskType.addData:
      case TaskType.addIndicator:
      case TaskType.addLayer:
      case TaskType.addPrompt:
      case TaskType.clearTask:
        return Container();
      case TaskType.addMcq:
        Task task = currentTask as AddMcqTask;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...(task as AddMcqTask).options.map((e) {
              return ElevatedButton(
                  onPressed: () {
                    onTaskFinish();
                  },
                  child: Text(e));
            })
          ],
        );
      case TaskType.waitTask:
        return ElevatedButton(
            onPressed: () {
              onTaskFinish();
            },
            child: Text((currentTask as WaitTask).btnText));
      case TaskType.addOptionChain:
      case TaskType.chooseCorrectOptionChainValue:
      case TaskType.highlightCorrectOptionChainValue:
      case TaskType.showPayOffGraph:
      case TaskType.addTab:
      case TaskType.removeTab:
      case TaskType.moveTab:
      case TaskType.popUpTask:
      case TaskType.showBottomSheet:
      case TaskType.showInsightsPage:
      case TaskType.chooseBucketRows:
      case TaskType.clearBucketRows:
      case TaskType.tableTask:
      case TaskType.highlightTableRow:
      case TaskType.showInsightsV2Page:
      case TaskType.showTools:
      case TaskType.openToolPanel:
        return Container();
    }
  }
}
