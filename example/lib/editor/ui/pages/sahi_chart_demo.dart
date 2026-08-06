import 'dart:convert';

import 'package:fin_chart/models/tasks/add_data.task.dart';
import 'package:fin_chart/models/tasks/add_indicator.task.dart';
import 'package:fin_chart/models/tasks/add_layer.task.dart';
import 'package:fin_chart/models/tasks/add_prompt.task.dart';
import 'package:fin_chart/models/tasks/open_tool_panel.task.dart';
import 'package:fin_chart/models/tasks/show_tools.task.dart';
import 'package:fin_chart/models/tasks/toggle_tool_visibility.task.dart';
import 'package:fin_chart/models/tasks/add_remove_tools.task.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:fin_chart/models/indicators/pivot_point.dart';
import 'package:fin_chart/models/indicators/pe.dart';
import 'package:fin_chart/models/indicators/pb.dart';
import 'package:fin_chart/models/indicators/supertrend.dart';
import 'package:fin_chart/models/indicators/vwap.dart';
import 'package:fin_chart/models/indicators/ev_ebitda.dart';
import 'package:fin_chart/models/indicators/ev_sales.dart';
import 'package:fin_chart/models/indicators/scanner_indicator.dart';
import 'package:fin_chart/models/indicators/roc.dart';
import 'package:fin_chart/models/layers/label.dart';
import 'package:fin_chart/models/layers/trend_line.dart';
import 'package:fin_chart/models/layers/horizontal_line.dart';
import 'package:fin_chart/models/layers/rect_area.dart';
import 'package:fin_chart/models/layers/circular_area.dart';
import 'package:fin_chart/models/layers/arrow.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/models/sahi_tools_model.dart';
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
import 'package:example/editor/ui/widgets/side_nav_panel.dart';

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
  AddRemoveToolsTask? _currentAddRemoveToolsTask;
  LayerType? _selectedLayerType;
  List<Offset> drawPoints = [];
  Offset? startingPoint;
  bool _isToolPanelOpen = false;
  OpenToolPanelTask? _currentToolPanelTask;

  String? _courseVideoUrl;
  bool _showCourseVideoBtn = false;

  List<JourneyState> journeys = [];
  String? _activeJourneyId;

  final List<AddCoreConceptTask> coreConcepts = [];

  String? _activeChartId;
  int _activeChartStartOffset = 0;
  int _activeChartEndOffset = -1;
  final Map<String, bool> _hasPlottedFirstChunk = {};

  List<ShowSideNavTask> sideNavTasks = [];
  bool isSideNavVisible = false;
  Map<String, String?> sideNavSelectedDesc = {};
  String? expandedSideNavId;

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
        final chartKey =
            task.chartId != null ? chartKeys[task.chartId] : _activeChartKey;
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

        final targetChartId = task.chartId ?? _activeChartId;
        if (targetChartId != null) {
          final chartTask = recipe.tasks
              .whereType<AddChartTabTask>()
              .where((t) => t.id == targetChartId)
              .firstOrNull;
          final startOffset = chartTask?.fromPoint ?? _activeChartStartOffset;
          final endOffset = chartTask?.tillPoint ?? _activeChartEndOffset;

          final isFirstChunk = _hasPlottedFirstChunk[targetChartId] != true;
          if (isFirstChunk) {
            from = startOffset;
          } else if (from < startOffset) {
            from = startOffset;
          }

          if (endOffset >= 0 && till > endOffset) {
            till = endOffset;
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
          if (targetChartId != null) {
            _hasPlottedFirstChunk[targetChartId] = true;
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
        final currentChartKey = _chartKeyForCurrentTab();
        if (currentChartKey?.currentState != null) {
          currentChartKey?.currentState?.clearChart();
        }
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
      case TaskType.showSideNav:
        final task = currentTask as ShowSideNavTask;
        setState(() {
          if (!sideNavTasks.any((t) => t.id == task.id)) {
            sideNavTasks.add(task);
          }
          isSideNavVisible = true;
          expandedSideNavId = task.id;
        });
        break;
      case TaskType.showTools:
        final task = currentTask as ShowToolsTask;
        setState(() {
          _currentShowToolsTask = task;
        });
        onTaskFinish();
        break;
      case TaskType.toggleToolVisibility:
        setState(() {});
        onTaskFinish();
        break;
      case TaskType.addRemoveTools:
        final task = currentTask as AddRemoveToolsTask;
        setState(() {
          _currentAddRemoveToolsTask = task;
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
      case TaskType.startJourney:
        final task = currentTask as StartJourneyTask;
        setState(() {
          journeys.add(JourneyState(id: task.journeyId));
          _activeJourneyId = task.journeyId;
        });
        onTaskFinish();
        break;
      case TaskType.completeJourney:
        setState(() {
          if (_activeJourneyId != null) {
            final journey = journeys.firstWhere(
              (j) => j.id == _activeJourneyId,
              orElse: () => JourneyState(id: ''),
            );
            journey.completed = true;
          }
        });
        onTaskFinish();
        break;
      case TaskType.attachVideoToJourney:
        final task = currentTask as AttachVideoToJourneyTask;
        if (_activeJourneyId == null) {
          onTaskFinish();
          break;
        }
        setState(() {
          task.journeyId = _activeJourneyId!;
          final journey = journeys.firstWhere(
            (j) => j.id == _activeJourneyId,
            orElse: () => JourneyState(id: _activeJourneyId!),
          );
          journey.videoUrl = task.videoUrl;
        });
        onTaskFinish();
        break;
      case TaskType.hideVideoBtnInJourney:
        final task = currentTask as HideVideoBtnInJourneyTask;
        if (_activeJourneyId == null) {
          onTaskFinish();
          break;
        }
        setState(() {
          task.journeyId = _activeJourneyId!;
          final journey = journeys.firstWhere(
            (j) => j.id == _activeJourneyId,
            orElse: () => JourneyState(id: _activeJourneyId!),
          );
          journey.hideVideoBtn = true;
        });
        onTaskFinish();
        break;
      case TaskType.addCourseVideo:
        final task = currentTask as AddCourseVideoTask;
        setState(() {
          _courseVideoUrl = task.videoUrl;
          _showCourseVideoBtn = true;
        });
        onTaskFinish();
        break;
      case TaskType.addCoreConcept:
        final addConceptTask = currentTask as AddCoreConceptTask;
        setState(() {
          coreConcepts.add(addConceptTask);
        });
        onTaskFinish();
        break;
      case TaskType.removeCoreConcept:
        setState(() {
          if (coreConcepts.isNotEmpty) {
            coreConcepts.removeLast();
          }
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

  GlobalKey<ChartState>? _chartKeyForCurrentTab() {
    if (currentPageIndex < 0 || currentPageIndex >= tabs.length) return null;
    final tab = tabs[currentPageIndex];
    if (tab["type"] != "chart") return null;
    final taskId = tab["taskId"];
    if (taskId == null) return null;
    return chartKeys[taskId];
  }

  void _onToolTap(String toolName) {
    final chartState = _chartKeyForCurrentTab()?.currentState;
    if (chartState == null) return;

    for (final indicatorType in IndicatorType.values) {
      if (indicatorType.name == toolName) {
        final config = _currentAddRemoveToolsTask?.getToolConfig(toolName);
        Indicator indicator;
        if (config != null) {
          indicator = Indicator.fromJson(json: config);
        } else {
          switch (indicatorType) {
            case IndicatorType.rsi:
              indicator = Rsi();
              break;
            case IndicatorType.macd:
              indicator = Macd();
              break;
            case IndicatorType.sma:
              indicator = Sma();
              break;
            case IndicatorType.ema:
              indicator = Ema();
              break;
            case IndicatorType.bollingerBand:
              indicator = BollingerBands();
              break;
            case IndicatorType.stochastic:
              indicator = Stochastic();
              break;
            case IndicatorType.atr:
              indicator = Atr();
              break;
            case IndicatorType.mfi:
              indicator = Mfi();
              break;
            case IndicatorType.adx:
              indicator = Adx();
              break;
            case IndicatorType.pivotPoint:
              indicator = PivotPoint();
              break;
            case IndicatorType.pe:
              indicator = Pe();
              break;
            case IndicatorType.pb:
              indicator = Pb();
              break;
            case IndicatorType.supertrend:
              indicator = Supertrend();
              break;
            case IndicatorType.vwap:
              indicator = Vwap();
              break;
            case IndicatorType.evEbitda:
              indicator = EvEbitda();
              break;
            case IndicatorType.evSales:
              indicator = EvSales();
              break;
            case IndicatorType.scanner:
              indicator = ScannerIndicator();
              break;
            case IndicatorType.roc:
              indicator = Roc();
              break;
          }
        }
        chartState.addIndicator(indicator);
        return;
      }
    }

    for (final layerType in LayerType.values) {
      if (layerType.name == toolName) {
        setState(() {
          _selectedLayerType = layerType;
        });
        chartState.updateLayerGettingAddedState(layerType);
        return;
      }
    }
  }

  void _onClearTools() {
    final chartState = _chartKeyForCurrentTab()?.currentState;
    if (chartState == null) return;
    chartState.clearAllTools();
    setState(() {
      _selectedLayerType = null;
      drawPoints.clear();
      startingPoint = null;
    });
  }

  void _onInteraction(Offset tapDownPoint, Offset updatedPoint) {
    if (_selectedLayerType == null) return;

    drawPoints.add(tapDownPoint);
    startingPoint = updatedPoint;
    Layer? layer;
    switch (_selectedLayerType) {
      case LayerType.label:
        layer = Label.fromTool(
            pos: drawPoints.first,
            label: "Text",
            textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold));
        break;
      case LayerType.trendLine:
        if (drawPoints.length >= 2) {
          layer = TrendLine.fromTool(
              from: drawPoints.first,
              to: drawPoints.last,
              startPoint: startingPoint!);
        }
        break;
      case LayerType.horizontalLine:
        layer = HorizontalLine.fromTool(value: drawPoints.first.dy);
        break;
      case LayerType.horizontalBand:
        layer = HorizontalBand.fromTool(
            value: drawPoints.first.dy, allowedError: 70);
        break;
      case LayerType.rectArea:
        if (drawPoints.length >= 2) {
          layer = RectArea.fromTool(
              topLeft: drawPoints.first,
              bottomRight: drawPoints.last,
              dragStartPos: startingPoint!);
        }
        break;
      case LayerType.circularArea:
        layer = CircularArea.fromTool(point: drawPoints.first);
        break;
      case LayerType.arrow:
        if (drawPoints.length >= 2) {
          layer = Arrow.fromTool(
              from: drawPoints.first,
              to: drawPoints.last,
              startPoint: startingPoint!);
        }
        break;
      case LayerType.verticalLine:
        layer = VerticalLine.fromTool(pos: tapDownPoint.dx);
        break;
      case LayerType.parallelChannel:
        if (drawPoints.length >= 2) {
          layer = ParallelChannel.fromTool(
              topLeft: drawPoints.first,
              bottomRight: drawPoints.last,
              dragPoint: startingPoint!);
        }
        break;
      case LayerType.arrowTextPointer:
        layer = ArrowTextPointer.fromTool(pos: drawPoints.first, label: "");
        break;
      case null:
        break;
    }

    if (layer != null) {
      layer = _applyLayerConfig(layer);
      final chartState = _chartKeyForCurrentTab()?.currentState;
      if (chartState != null) {
        setState(() {
          _selectedLayerType = null;
          drawPoints.clear();
        });
        chartState.addLayerUsingTool(layer);
      }
    }
  }

  Layer _applyLayerConfig(Layer layer) {
    final config =
        _currentAddRemoveToolsTask?.getToolConfig(layer.type.name);
    if (config == null) return layer;

    switch (layer.type) {
      case LayerType.horizontalLine:
        final c = HorizontalLine.fromJson(json: config);
        final l = layer as HorizontalLine;
        l.color = c.color;
        l.strokeWidth = c.strokeWidth;
        break;
      case LayerType.trendLine:
        final c = TrendLine.fromJson(json: config);
        final l = layer as TrendLine;
        l.color = c.color;
        l.strokeWidth = c.strokeWidth;
        l.endPointRadius = c.endPointRadius;
        break;
      case LayerType.label:
        final c = Label.fromJson(json: config);
        final l = layer as Label;
        l.label = c.label;
        l.textStyle = c.textStyle;
        break;
      case LayerType.horizontalBand:
        final c = HorizontalBand.fromJson(json: config);
        final l = layer as HorizontalBand;
        l.color = c.color;
        l.allowedError = c.allowedError;
        break;
      case LayerType.rectArea:
        final c = RectArea.fromJson(json: config);
        final l = layer as RectArea;
        l.color = c.color;
        l.alpha = c.alpha;
        l.strokeWidth = c.strokeWidth;
        l.endPointRadius = c.endPointRadius;
        l.isLocked = c.isLocked;
        break;
      case LayerType.circularArea:
        final c = CircularArea.fromJson(json: config);
        final l = layer as CircularArea;
        l.color = c.color;
        l.radius = c.radius;
        break;
      case LayerType.arrow:
        final c = Arrow.fromJson(json: config);
        final l = layer as Arrow;
        l.color = c.color;
        l.strokeWidth = c.strokeWidth;
        l.endPointRadius = c.endPointRadius;
        l.arrowheadSize = c.arrowheadSize;
        l.isArrowheadAtTo = c.isArrowheadAtTo;
        break;
      case LayerType.parallelChannel:
        final c = ParallelChannel.fromJson(json: config);
        final l = layer as ParallelChannel;
        l.color = c.color;
        l.strokeWidth = c.strokeWidth;
        l.channelAlpha = c.channelAlpha;
        l.endPointRadius = c.endPointRadius;
        break;
      case LayerType.arrowTextPointer:
        final c = ArrowTextPointer.fromJson(json: config);
        final l = layer as ArrowTextPointer;
        l.label = c.label;
        l.textAlignment = c.textAlignment;
        break;
      case LayerType.verticalLine:
        break;
    }
    return layer;
  }

  List<SahiToolsModel> _buildToolsList() {
    final List<String> allToolNames = [];
    for (final indicator in IndicatorType.values) {
      allToolNames.add(indicator.name);
    }
    for (final layer in LayerType.values) {
      allToolNames.add(layer.name);
    }

    final Map<String, bool> visibility = {};
    final Map<String, bool> enabled = {};

    final executedTasks = recipe.tasks.sublist(0, taskPointer);
    for (final t in executedTasks) {
      if (t is ShowToolsTask) {
        for (final tool in t.tools) {
          visibility[tool.title] = tool.isVisible;
          enabled[tool.title] = tool.isEnabled;
        }
      } else if (t is ToggleToolVisibilityTask) {
        visibility.addAll(t.visibility);
      } else if (t is AddRemoveToolsTask) {
        enabled.addAll(t.enabled);
      }
    }

    return allToolNames
        .where((name) => visibility[name] ?? false)
        .map((name) => SahiToolsModel(
              title: name,
              isVisible: true,
              isEnabled: enabled[name] ?? false,
            ))
        .toList();
  }

  void onTaskFinish() {
    taskPointer += 1;
    if (taskPointer < recipe.tasks.length) {
      currentTask = recipe.tasks[taskPointer];
      onTaskRun();
    }
  }

  void closeSideNav({bool moveToNextNode = false}) {
    if (!isSideNavVisible) return;
    setState(() {
      isSideNavVisible = false;
    });
    if (moveToNextNode) {
      onTaskFinish();
    }
  }

  Widget _buildSideNavPanel() {
    return SideNavPanel(
      tasks: sideNavTasks,
      expandedId: expandedSideNavId,
      onExpandedChange: (id) {
        setState(() {
          expandedSideNavId = id;
        });
      },
      selectedDescriptions: sideNavSelectedDesc,
      onDescriptionSelect: (taskId, desc) {
        setState(() {
          sideNavSelectedDesc[taskId] = desc;
        });
      },
      onClose: () {
        closeSideNav(moveToNextNode: true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SahiTopBar(
                  tabs: tabs,
                  currentPageIndex: currentPageIndex,
                  onTabTap: navigateToPage,
                  activeJourney: _activeJourneyId != null
                      ? journeys.firstWhere(
                          (j) => j.id == _activeJourneyId,
                          orElse: () => JourneyState(id: ''),
                        )
                      : null,
                  courseVideoUrl: _courseVideoUrl,
                  showCourseVideoBtn: _showCourseVideoBtn,
                ),
                Divider(height: 1, thickness: 1, color: colors.sahiDivider),
                if (_currentShowToolsTask != null)
                  SahiToolsBar(
                    tools: _buildToolsList(),
                    onToolTap: _onToolTap,
                    trailing: GestureDetector(
                      onTap: _onClearTools,
                      child: Container(
                        margin: const EdgeInsets.only(left: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: colors.sahiTabBorder,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.delete_outline,
                                size: 14, color: colors.sahiTextPrimary),
                            const SizedBox(width: 4),
                            Text(
                              'Clear',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: colors.sahiTextPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: SahiContentArea(
                    promptText: promptText,
                    hintText: hintText,
                    coreConcepts: coreConcepts,
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
                          final taskId =
                              tabs[currentPageIndex]["taskId"] ?? "";
                          userSelectedRows[taskId] ??= {};
                          userSelectedRows[taskId]![tableIdx] = rowIndices;
                        });
                      });
                    },
                    onInteraction: _onInteraction,
                  ),
                ),
                SahiUserActionArea(
                  currentTask: currentTask,
                  onTaskFinish: onTaskFinish,
                ),
              ],
            ),
            if (currentTask.taskType == TaskType.showSideNav &&
                isSideNavVisible)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    closeSideNav(moveToNextNode: true);
                  },
                  child: Container(color: Colors.black.withValues(alpha: 0.4)),
                ),
              ),
            if (currentTask.taskType == TaskType.showSideNav &&
                isSideNavVisible)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 320,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(left: BorderSide(color: colors.sahiDivider)),
                  ),
                  child: _buildSideNavPanel(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
