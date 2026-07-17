import 'dart:convert';
import 'package:example/dialog/add_tab_dialog.dart';
import 'package:example/dialog/add_chart_tab_dialog.dart';
import 'package:example/dialog/choose_bucket_rows_dialog.dart';
import 'package:example/dialog/edit_added_tab_dialog.dart';
import 'package:example/dialog/edit_chart_tab_dialog.dart';
import 'package:example/dialog/edit_move_tab_dialog.dart';
import 'package:example/dialog/open_tools_panel_dialog.dart';
import 'package:example/dialog/show_tools_dialog.dart';
import 'package:example/dialog/toggle_tool_visibility_dialog.dart';
import 'package:example/dialog/add_remove_tools_dialog.dart';
import 'package:example/dialog/pay_off_graph_dialog.dart';
import 'package:example/dialog/show_all_added_tabs_dialog.dart';
import 'package:example/dialog/show_all_option_chains_dialog.dart';
import 'package:example/dialog/show_bottom_sheet_dialog.dart';
import 'package:example/dialog/show_insights_page_dialog.dart';
import 'package:example/dialog/show_insights_pagev2_dialog.dart';
import 'package:example/dialog/show_option_chain_by_id.dart';
import 'package:example/dialog/show_popup_dialog.dart';
import 'package:example/dialog/show_table_task_dialog.dart';
import 'package:example/dialog/add_data_dialog.dart';
import 'package:example/editor/ui/pages/sahi_chart_demo.dart';
import 'package:example/editor/ui/widget/markdown_textfield.dart';
import 'package:fin_chart/fin_chart.dart';
import 'package:fin_chart/models/enums/mcq_arrangment_type.dart';
import 'package:fin_chart/models/fundamental/fundamental_event.dart';
import 'package:fin_chart/models/indicators/ev_ebitda.dart';
import 'package:fin_chart/models/indicators/ev_sales.dart';
import 'package:fin_chart/models/indicators/pivot_point.dart';
import 'package:fin_chart/models/indicators/pe.dart';
import 'package:fin_chart/models/indicators/pb.dart';
import 'package:fin_chart/models/indicators/roc.dart';
import 'package:fin_chart/models/indicators/scanner_indicator.dart';
import 'package:fin_chart/models/indicators/supertrend.dart';
import 'package:fin_chart/models/indicators/vwap.dart';
import 'package:fin_chart/models/region/main_plot_region.dart';
import 'package:fin_chart/models/scanners/scanner_result.dart';
import 'package:fin_chart/models/tasks/add_data.task.dart';
import 'package:fin_chart/models/tasks/add_indicator.task.dart';
import 'package:fin_chart/models/tasks/add_layer.task.dart';
import 'package:fin_chart/models/tasks/add_prompt.task.dart';
import 'package:fin_chart/models/tasks/add_option_chain.task.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/recipe.dart';
import 'package:fin_chart/models/tasks/choose_correct_option_chain_task.dart';
import 'package:fin_chart/models/tasks/clear_bucket_rows_task.dart';
import 'package:fin_chart/models/tasks/highlight_table_row_task.dart';
import 'package:fin_chart/models/tasks/show_bottom_sheet.task.dart';
import 'package:fin_chart/models/tasks/show_insights_page.task.dart';
import 'package:fin_chart/models/tasks/table_task.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/models/tasks/wait.task.dart';
import 'package:fin_chart/models/tasks/show_tools.task.dart';
import 'package:fin_chart/models/tasks/toggle_tool_visibility.task.dart';
import 'package:fin_chart/models/tasks/add_remove_tools.task.dart';
import 'package:fin_chart/models/sahi_tools_model.dart';
import 'package:fin_chart/models/tasks/open_tool_panel.task.dart';
import 'package:example/editor/ui/widget/blinking_text.dart';
import 'package:example/editor/ui/widget/indicator_type_dropdown.dart';
import 'package:example/editor/ui/widget/layer_type_dropdown.dart';
import 'package:example/editor/ui/widget/task_list_widget.dart';
import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:fin_chart/models/layers/arrow.dart';
import 'package:fin_chart/models/layers/circular_area.dart';
import 'package:fin_chart/models/layers/horizontal_line.dart';
import 'package:fin_chart/models/layers/label.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/models/layers/rect_area.dart';
import 'package:fin_chart/models/layers/trend_line.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/ui/add_event_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:example/dialog/add_option_chain_dialog.dart';
import 'package:fin_chart/models/tasks/choose_bucket_rows_task.dart';
import 'package:example/dialog/clear_bucket_rows_dialog.dart';
import 'package:example/dialog/show_highlight_table_row_dialog.dart';

class EditorPage extends StatefulWidget {
  final String? recipeStr;

  const EditorPage({super.key, this.recipeStr});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final GlobalKey<ChartState> _chartKey = GlobalKey();
  List<ICandle> candleData = [];
  List<Task> tasks = [];
  int insertPosition = -1;

  LayerType? _selectedLayerType;
  IndicatorType? _selectedIndicatorType;
  List<Offset> drawPoints = [];
  Offset startingPoint = Offset.zero;
  PlotRegion? selectedRegion;

  TaskType? _currentTaskType;

  bool _isRecording = false;

  Recipe? recipe;

  List<FundamentalEvent> fundamentalEvents = [];
  bool isWaitingForEventPosition = false;
  FundamentalEvent? selectedEvent;

  ChartType _chartType = ChartType.candlestick;

  Timer? _autosaveTimer;
  static const String _savedRecipeKey = 'saved_recipe';

  ScannerResult? _selectedScannerResult;

  // Chart tab management
  List<Map<String, dynamic>> _chartTabs = [];
  int _activeChartTabIndex = -1;
  Map<String, List<ICandle>> _chartCandleData = {};

  GlobalKey<ChartState> get _activeChartKey {
    if (_activeChartTabIndex >= 0 && _activeChartTabIndex < _chartTabs.length) {
      return _chartTabs[_activeChartTabIndex]['key'] as GlobalKey<ChartState>;
    }
    return _chartKey;
  }

  bool get _hasChart => tasks.any((t) => t is AddChartTabTask);

  List<ICandle> _activeCandles() {
    if (_chartTabs.isNotEmpty &&
        _activeChartTabIndex >= 0 &&
        _activeChartTabIndex < _chartTabs.length) {
      final activeId = _chartTabs[_activeChartTabIndex]['id'] as String;
      return _chartCandleData[activeId] ?? [];
    }
    return candleData;
  }

  List<ICandle> _buildFlattenedCandleDataForSave() {
    if (_chartTabs.isEmpty) {
      return List<ICandle>.from(candleData);
    }

    final flattened = <ICandle>[];
    int cursor = 0;

    for (final tab in _chartTabs) {
      final tabId = tab['id'] as String;
      final tabData = List<ICandle>.from(_chartCandleData[tabId] ?? const []);
      AddChartTabTask? tabTask;
      for (final task in tasks) {
        if (task is AddChartTabTask && task.id == tabId) {
          tabTask = task;
          break;
        }
      }

      if (tabTask == null) {
        continue;
      }

      tabTask.fromPoint = cursor;
      tabTask.tillPoint = cursor + tabData.length;
      cursor = tabTask.tillPoint;
      flattened.addAll(tabData);
    }

    return flattened;
  }

  int _getChartBaseOffsetByTabIndex(int tabIndex) {
    if (tabIndex <= 0) return 0;

    int offset = 0;
    for (int i = 0; i < tabIndex && i < _chartTabs.length; i++) {
      final tabId = _chartTabs[i]['id'] as String;
      offset += (_chartCandleData[tabId] ?? const <ICandle>[]).length;
    }
    return offset;
  }

  int _getChartBaseOffsetById(String chartId) {
    final tabIndex = _chartTabs.indexWhere((tab) => tab['id'] == chartId);
    if (tabIndex == -1) return 0;
    return _getChartBaseOffsetByTabIndex(tabIndex);
  }

  int _getLastTillPointForChart(String chartId, int fallbackBaseOffset) {
    bool isCurrentChart = false;
    int lastTill = fallbackBaseOffset;

    for (final task in tasks) {
      if (task is AddChartTabTask) {
        if (isCurrentChart) {
          break;
        }
        isCurrentChart = task.id == chartId;
      } else if (isCurrentChart && task is AddDataTask) {
        if (task.tillPoint > lastTill) {
          lastTill = task.tillPoint;
        }
      }
    }

    return lastTill;
  }

  String? _chartIdForTask(Task targetTask, {List<Task>? sourceTasks}) {
    final taskList = sourceTasks ?? tasks;
    String? currentChartId;

    for (final task in taskList) {
      if (task is AddChartTabTask) {
        currentChartId = task.id;
      }
      if (identical(task, targetTask)) {
        return currentChartId;
      }
    }
    return null;
  }

  GlobalKey<ChartState>? _chartKeyForId(String? chartId) {
    if (chartId == null) {
      return _chartKey;
    }
    for (final tab in _chartTabs) {
      if (tab['id'] == chartId) {
        return tab['key'] as GlobalKey<ChartState>;
      }
    }
    return null;
  }

  String? _currentChartId() {
    if (_chartTabs.isEmpty ||
        _activeChartTabIndex < 0 ||
        _activeChartTabIndex >= _chartTabs.length) {
      return null;
    }
    return _chartTabs[_activeChartTabIndex]['id'] as String;
  }

  List<FundamentalEvent> _activeChartFundamentalEvents() {
    final chartState = _activeChartKey.currentState;
    if (chartState == null) {
      return <FundamentalEvent>[];
    }
    for (final region in chartState.regions) {
      if (region is MainPlotRegion) {
        return region.fundamentalEvents;
      }
    }
    return <FundamentalEvent>[];
  }

  void _removeChartTabById(String chartId) {
    final tabIndex = _chartTabs.indexWhere((tab) => tab['id'] == chartId);
    if (tabIndex == -1) return;

    _chartTabs.removeAt(tabIndex);
    _chartCandleData.remove(chartId);

    if (_chartTabs.isEmpty) {
      _activeChartTabIndex = -1;
      return;
    }

    if (_activeChartTabIndex >= _chartTabs.length) {
      _activeChartTabIndex = _chartTabs.length - 1;
    } else if (_activeChartTabIndex > tabIndex) {
      _activeChartTabIndex -= 1;
    }
  }

  void _activateChartTab(int index) {
    if (index < 0 || index >= _chartTabs.length) return;
    if (_activeChartTabIndex == index) return;
    setState(() {
      _activeChartTabIndex = index;
    });
  }

  void _deleteSelectedScannerResult() {
    if (_selectedScannerResult != null) {
      _activeChartKey.currentState?.removeSelectedScannerResult();
      setState(() {
        _selectedScannerResult = null;
      });
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: _currentTaskType != null
          ? BlinkingText(text: "Waiting for ${_currentTaskType?.name}")
          : _isRecording
              ? const BlinkingText(
                  text: "RECORDING",
                  style: TextStyle(color: Colors.red, fontSize: 24),
                )
              : const Text("Trade:able Charts"),
      actions: [
        if (_selectedScannerResult != null)
          IconButton(
            onPressed: _deleteSelectedScannerResult,
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: "Delete Scanner Finding",
          ),
        if (selectedEvent != null)
          IconButton(
            onPressed: _deleteSelectedEvent,
            icon: const Icon(Icons.delete),
            tooltip: "Delete Event",
          ),
        Switch(
          value: _isRecording,
          onChanged: (value) {
            setState(() {
              _isRecording = value;
              if (value) {
                _currentTaskType = null;
              }
            });
          },
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SahiChartDemo(
                  recipeDataJson: jsonEncode(
                    Recipe(
                      data: candleData,
                      chartSettings:
                          _activeChartKey.currentState!.getChartSettings(),
                      tasks: tasks,
                      fundamentalEvents: fundamentalEvents,
                    ).toJson(),
                  ),
                ),
              ),
            );
          },
          iconSize: 42,
          icon: const Icon(Icons.play_arrow_rounded),
        ),
        IconButton(
          onPressed: () {
            Clipboard.setData(
              ClipboardData(
                text: jsonEncode(
                  Recipe(
                    data: candleData,
                    chartSettings:
                        _activeChartKey.currentState!.getChartSettings(),
                    tasks: tasks,
                    fundamentalEvents: fundamentalEvents,
                  ).toJson(),
                ),
              ),
            ).then((_) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("recipe to clipboar")),
                );
              }
            });
          },
          iconSize: 42,
          icon: const Icon(Icons.copy_all_rounded),
        ),
      ],
    );
  }

  void _deleteSelectedEvent() {
    if (selectedEvent != null) {
      setState(() {
        fundamentalEvents.removeWhere((event) => event.id == selectedEvent!.id);
        // Update the chart to reflect the removal
        for (var region in _activeChartKey.currentState!.regions) {
          if (region is MainPlotRegion) {
            region.fundamentalEvents
                .removeWhere((event) => event.id == selectedEvent!.id);
          }
        }
        selectedEvent = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.recipeStr != null) {
      recipe = Recipe.fromJson(jsonDecode(widget.recipeStr!));
      _chartType = recipe!.chartSettings.chartType;
      populateRecipe(recipe!);
    }

    // Setup autosave timer
    _autosaveTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _saveCurrentRecipe();
    });
  }

  void _saveCurrentRecipe() {
    final flattenedData = _buildFlattenedCandleDataForSave();
    if (flattenedData.isEmpty) return; // Don't save empty states

    try {
      final chartState = _activeChartKey.currentState ?? _chartKey.currentState;
      if (chartState == null) {
        return;
      }

      // Keep the editor-level backing list consistent with what is persisted.
      candleData = List<ICandle>.from(flattenedData);

      final recipeData = Recipe(
        data: flattenedData,
        chartSettings: chartState.getChartSettings(),
        tasks: tasks,
        fundamentalEvents: fundamentalEvents,
      );

      final jsonString = jsonEncode(recipeData.toJson());
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(_savedRecipeKey, jsonString);
        if (kDebugMode) {
          print('Chart recipe autosaved successfully.');
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error autosaving chart recipe: $e');
      }
    }
  }

  populateRecipe(Recipe recipe) async {
    await Future.delayed(const Duration(seconds: 1));

    // First pass: build _chartCandleData before any widgets are built
    Map<String, List<ICandle>> chartData = {};
    final chartTabTasks = recipe.tasks.whereType<AddChartTabTask>().toList();
    final hasExplicitTabRanges =
        chartTabTasks.any((task) => task.fromPoint > 0 || task.tillPoint >= 0);

    if (hasExplicitTabRanges) {
      for (final task in chartTabTasks) {
        final int safeFrom = task.fromPoint.clamp(0, recipe.data.length);
        final int rawTill =
            task.tillPoint < 0 ? recipe.data.length : task.tillPoint;
        final int safeTill = rawTill.clamp(safeFrom, recipe.data.length);
        chartData[task.id] = recipe.data.sublist(safeFrom, safeTill);
      }
    } else {
      String? activeTabId;
      for (final task in recipe.tasks) {
        if (task is AddChartTabTask) {
          chartData[task.id] = [];
          activeTabId = task.id;
        } else if (task is AddDataTask && activeTabId != null) {
          final int safeFrom = task.fromPoint.clamp(0, recipe.data.length);
          final int safeTill =
              task.tillPoint.clamp(safeFrom, recipe.data.length);
          final dataSlice = recipe.data.sublist(safeFrom, safeTill);
          chartData[activeTabId] = [
            ...chartData[activeTabId]!,
            ...dataSlice,
          ];
        }
      }
    }

    setState(() {
      candleData.addAll(recipe.data);
      tasks.addAll(recipe.tasks);
      fundamentalEvents.addAll(recipe.fundamentalEvents ?? []);
      _chartCandleData = chartData;

      for (Task task in tasks) {
        if (task is AddChartTabTask) {
          final chartKey = GlobalKey<ChartState>();
          _chartTabs.add({
            'id': task.id,
            'title': task.tabTitle,
            'key': chartKey,
          });
        }
      }

      if (_chartTabs.isNotEmpty) {
        _activeChartTabIndex = 0;
      } else {
        _chartKey.currentState?.addData(candleData);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chartTabs.isEmpty) {
        _chartKey.currentState?.addData(candleData);
      }

      GlobalKey<ChartState>? activeKey = _chartTabs.isNotEmpty
          ? _chartTabs[0]['key'] as GlobalKey<ChartState>
          : _chartKey;
      String? activeChartId =
          _chartTabs.isNotEmpty ? _chartTabs[0]['id'] as String : null;

      for (Task task in tasks) {
        switch (task.taskType) {
          case TaskType.addPrompt:
          case TaskType.waitTask:
          case TaskType.addMcq:
          case TaskType.clearTask:
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
            break;
          case TaskType.addData:
            final addDataTask = task as AddDataTask;
            final resolvedChartId = addDataTask.chartId ?? activeChartId;
            final chartBaseOffset = resolvedChartId == null
                ? 0
                : _getChartBaseOffsetById(resolvedChartId);
            final localPos =
                (addDataTask.tillPoint - chartBaseOffset - 1).toDouble();
            VerticalLine layer = VerticalLine.fromRecipe(
                id: addDataTask.verticleLineId,
                pos: localPos < 0 ? 0 : localPos);
            layer.isLocked = true;
            activeKey?.currentState?.addLayerAtRegion(
                recipe.chartSettings.mainPlotRegionId, layer);
            break;
          case TaskType.addIndicator:
            final indicatorTask = task as AddIndicatorTask;
            final indicatorChartKey =
                _chartKeyForId(indicatorTask.chartId) ?? activeKey;
            indicatorChartKey?.currentState
                ?.addIndicator(indicatorTask.indicator);
            break;
          case TaskType.addLayer:
            AddLayerTask t = task as AddLayerTask;
            final layerChartKey =
                _chartKeyForId(t.chartId ?? _chartIdForTask(t)) ?? activeKey;
            layerChartKey?.currentState?.addLayerAtRegion(t.regionId, t.layer);
            break;
          default:
            break;
        }
      }
    });
  }

  _updateTaskList(Task task) {
    setState(() {
      tasks.insert(insertPosition, task);
      _currentTaskType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(flex: 1, child: _buildTaskListWidget()),
          if (_hasChart) _buildChartTabBar(),
          Expanded(
              flex: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: _isRecording
                      ? Colors.red.withAlpha(50)
                      : Colors.white.withAlpha(100),
                ),
                child: _buildChartArea(),
              )),
          if (_hasChart) Expanded(flex: 1, child: _buildToolBox()),
        ],
      )),
    );
  }

  _onLayerSelect(PlotRegion region, Layer layer) {
    setState(() {
      _selectedScannerResult = null;
    });
    if (_currentTaskType == TaskType.addLayer) {
      _updateTaskList(
        AddLayerTask(
          regionId: region.id,
          layer: layer,
          chartId: _currentChartId(),
        ),
      );
    }
  }

  void _onRegionSelect(PlotRegion region) {
    selectedRegion = region;

    if (region is MainPlotRegion && region.selectedEvent != null) {
      setState(() {
        selectedEvent = region.selectedEvent;
        _selectedScannerResult = null;
      });
    } else {
      setState(() {
        selectedEvent = null;
      });
    }
  }

  _onIndicatorSelect(Indicator indicator) {
    if (_currentTaskType == TaskType.addIndicator) {
      _updateTaskList(
        AddIndicatorTask(
          indicator: indicator,
          chartId: _currentChartId(),
        ),
      );
    }
  }

  _onInteraction(Offset tapDownPoint, Offset updatedPoint) {
    if (_selectedLayerType != null) {
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
                startPoint: startingPoint);
          } else {
            layer = null;
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
                dragStartPos: startingPoint);
          } else {
            layer = null;
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
                startPoint: startingPoint);
          } else {
            layer = null;
          }
          break;
        case LayerType.verticalLine:
          layer = VerticalLine.fromTool(pos: tapDownPoint.dx);
          layer.isLocked = true;
          final String currentChartId = _chartTabs.isNotEmpty
              ? _chartTabs[_activeChartTabIndex]['id'] as String
              : '';

          final int chartBaseOffset = _chartTabs.isNotEmpty
              ? _getChartBaseOffsetByTabIndex(_activeChartTabIndex)
              : 0;
          final int localDx = tapDownPoint.dx.round();
          final int globalDx = chartBaseOffset + localDx;

          final int lastTill = currentChartId.isNotEmpty
              ? _getLastTillPointForChart(currentChartId, chartBaseOffset)
              : candleData.length;
          final int fromPoint =
              currentChartId.isNotEmpty ? lastTill : candleData.length;

          if (globalDx + 1 <= fromPoint) {
            break;
          }

          _updateTaskList(AddDataTask(
              fromPoint: fromPoint,
              tillPoint: globalDx + 1,
              verticleLineId: layer.id,
              chartId: currentChartId.isNotEmpty ? currentChartId : null));
          break;
        case null:
          layer = null;
          break;
        case LayerType.parallelChannel:
          if (drawPoints.length >= 2) {
            layer = ParallelChannel.fromTool(
                topLeft: drawPoints.first,
                bottomRight: drawPoints.last,
                dragPoint: startingPoint);
          } else {
            layer = null;
          }
          break;
        case LayerType.arrowTextPointer:
          layer = ArrowTextPointer.fromTool(pos: drawPoints.first, label: "");
          break;
      }
      setState(() {
        if (layer != null) {
          _selectedLayerType = null;
          drawPoints.clear();
          layer.updateRegionProp(
              leftPos: selectedRegion!.leftPos,
              topPos: selectedRegion!.topPos,
              rightPos: selectedRegion!.rightPos,
              bottomPos: selectedRegion!.bottomPos,
              xStepWidth: selectedRegion!.xStepWidth,
              xOffset: selectedRegion!.xOffset,
              yMinValue: selectedRegion!.yMinValue,
              yMaxValue: selectedRegion!.yMaxValue);
          _activeChartKey.currentState?.addLayerUsingTool(layer);
        }
      });
    }
    if (isWaitingForEventPosition) {
      setState(() {
        isWaitingForEventPosition = false;
        final candles = _activeCandles();
        if (candles.isEmpty) {
          return;
        }
        final int candleIndex =
            tapDownPoint.dx.round().clamp(0, candles.length - 1);
        DateTime candleDate = candles[candleIndex].date;

        // Show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddEventDialog(
              index: tapDownPoint.dx.round(),
              onEventAdded: (event) {
                setState(() {
                  _activeChartKey.currentState?.addFundamentalEvent(event);
                  fundamentalEvents.add(event);
                });
              },
              preSelectedDate: candleDate,
            );
          },
        );
      });
    }
  }

  Widget _buildTaskListWidget() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(100),
      ),
      child: TaskListWidget(
        task: tasks,
        onTaskAdd: _onTaskAdd,
        onTaskClick: _onTaskClick,
        onTaskEdit: _onTaskEdit,
        onTaskDelete: _onTaskDelete,
        disabledTaskTypes: _hasChart
            ? {}
            : {
                TaskType.addData,
                TaskType.addIndicator,
                TaskType.addLayer,
              },
      ),
    );
  }

  _onTaskAdd(TaskType taskType, int pos) {
    setState(() {
      insertPosition = (pos >= 0 && pos <= tasks.length) ? pos : tasks.length;
      switch (taskType) {
        case TaskType.addIndicator:
        case TaskType.addLayer:
          _currentTaskType = taskType;
          break;
        case TaskType.addData:
          _activeChartKey.currentState
              ?.updateLayerGettingAddedState(LayerType.verticalLine);
          _currentTaskType = taskType;
          _selectedLayerType = LayerType.verticalLine;
          break;
        case TaskType.addPrompt:
          prompt();
          break;
        case TaskType.waitTask:
          waitTaskPrompt();
          break;
        case TaskType.addMcq:
          mcqPrompt();
          break;
        case TaskType.clearTask:
          _updateTaskList(ClearTask());
          break;
        case TaskType.addOptionChain:
          optionChainPrompt();
          break;
        case TaskType.chooseCorrectOptionChainValue:
          showOptionChain();
          break;
        case TaskType.highlightCorrectOptionChainValue:
          selectOptionChainToHighlight();
          break;
        case TaskType.showPayOffGraph:
          showPayoffGraphTemplate();
          break;
        case TaskType.addTab:
          showAddTab();
          break;
        case TaskType.addChartTab:
          showAddChartTab();
          break;
        case TaskType.removeTab:
          showAllAddedTabs();
          break;
        case TaskType.moveTab:
          moveToTab();
          break;
        case TaskType.popUpTask:
          showPopupTask();
          break;
        case TaskType.showBottomSheet:
          showBottomSheetTask();
          break;
        case TaskType.showInsightsPage:
          showInsightsPageTask();
          break;
        case TaskType.chooseBucketRows:
          showChooseBucketRows();
          break;
        case TaskType.clearBucketRows:
          showClearBucketRows();
          break;
        case TaskType.tableTask:
          showTableTask();
          break;
        case TaskType.highlightTableRow:
          highlightTableRowPrompt();
          break;
        case TaskType.showInsightsV2Page:
          showInsightsPageV2Task();
          break;
        case TaskType.showTools:
          _showShowToolsDialog();
          break;
        case TaskType.toggleToolVisibility:
          _showToggleToolVisibilityDialog();
          break;
        case TaskType.addRemoveTools:
          _showAddRemoveToolsDialog();
          break;
        case TaskType.openToolPanel:
          _showOpenToolsPanelDialog();
          break;
      }
    });
  }

  _onTaskClick(Task task) {
    task.buildDialog(context: context);
  }

  _onTaskEdit(Task task) {
    switch (task.taskType) {
      case TaskType.addData:
      case TaskType.addIndicator:
      case TaskType.addLayer:
      case TaskType.clearTask:
        break;
      case TaskType.addPrompt:
        editPrompt(task as AddPromptTask);
        break;
      case TaskType.waitTask:
        editWaitTask(task as WaitTask);
        break;
      case TaskType.addMcq:
        editMcqPrompt(task as AddMcqTask);
        break;
      case TaskType.addOptionChain:
        editOptionChain(task as AddOptionChainTask);
        break;
      case TaskType.chooseCorrectOptionChainValue:
        editHighlightedOptionChainData(
            task as ChooseCorrectOptionValueChainTask);
        break;
      case TaskType.highlightCorrectOptionChainValue:
        selectOptionChainToHighlight();
        break;
      case TaskType.showPayOffGraph:
        editPayoffGraph(task as ShowPayOffGraphTask);
        break;
      case TaskType.addTab:
        editAddedTab(task as AddTabTask);
        break;
      case TaskType.addChartTab:
        editAddedChartTab(task as AddChartTabTask);
        break;
      case TaskType.removeTab:
        break;
      case TaskType.moveTab:
        editMoveToTab(task as MoveTabTask);
        break;
      case TaskType.popUpTask:
        editPopupTask(task as ShowPopupTask);
        break;
      case TaskType.showBottomSheet:
        editBottomSheetTask(task as ShowBottomSheetTask);
        break;
      case TaskType.showInsightsPage:
        editInsightsPageTask(task as ShowInsightsPageTask);
        break;
      case TaskType.chooseBucketRows:
        editChooseBucketRows(task as ChooseBucketRowsTask);
        break;
      case TaskType.clearBucketRows:
        editClearBucketRows(task as ClearBucketRowsTask);
        break;
      case TaskType.tableTask:
        editTableTask(task as TableTask);
        break;
      case TaskType.highlightTableRow:
        editHighlightTableRowTask(task as HighlightTableRowTask);
        break;
      case TaskType.showInsightsV2Page:
        editInsightsPageV2Task(task as ShowInsightsPageV2Task);
        break;
      case TaskType.showTools:
        _editShowToolsDialog(task as ShowToolsTask);
        break;
      case TaskType.toggleToolVisibility:
        _editToggleToolVisibilityDialog(task as ToggleToolVisibilityTask);
        break;
      case TaskType.addRemoveTools:
        _editAddRemoveToolsDialog(task as AddRemoveToolsTask);
        break;
      case TaskType.openToolPanel:
        _editOpenToolsPanelDialog(task as OpenToolPanelTask);
        break;
    }
  }

  _onTaskDelete(Task task) {
    setState(() {
      if (task is AddChartTabTask) {
        final startIndex = tasks.indexOf(task);
        if (startIndex == -1) {
          return;
        }

        int endIndex = tasks.length;
        for (int i = startIndex + 1; i < tasks.length; i++) {
          if (tasks[i] is AddChartTabTask) {
            endIndex = i;
            break;
          }
        }

        final relatedTasks = tasks.sublist(startIndex, endIndex);
        final chartKey = _chartKeyForId(task.id);
        if (chartKey?.currentState != null) {
          for (final related in relatedTasks) {
            if (related is AddDataTask) {
              chartKey!.currentState!.removeLayerById(related.verticleLineId);
            }
          }
        }

        tasks.removeRange(startIndex, endIndex);
        _removeChartTabById(task.id);
        candleData = _buildFlattenedCandleDataForSave();
        return;
      }

      if (task is AddDataTask) {
        final chartId = task.chartId ?? _chartIdForTask(task);
        _chartKeyForId(chartId)
            ?.currentState
            ?.removeLayerById(task.verticleLineId);
      } else if (task is AddIndicatorTask) {
        _chartKeyForId(task.chartId)
            ?.currentState
            ?.removeIndicator(task.indicator);
      } else if (task is AddLayerTask) {
        final chartId = task.chartId ?? _chartIdForTask(task);
        _chartKeyForId(chartId)?.currentState?.removeLayerById(task.layer.id);
      }

      tasks.remove(task);
      candleData = _buildFlattenedCandleDataForSave();
    });
  }

  void prompt() async {
    await showPromptDialog(context: context).then((data) {
      if (data != null) {
        _updateTaskList(data);
      }
    });
  }

  void editPrompt(AddPromptTask task) async {
    await showPromptDialog(context: context, initialTask: task).then((data) {
      setState(() {
        if (data != null) {
          setState(() {
            task.promptText = data.promptText;
            task.isExplanation = data.isExplanation;
          });
        }
      });
    });
  }

  void waitTaskPrompt() async {
    await showWaitTaskDialog(context: context).then((data) {
      if (data != null) {
        _updateTaskList(data);
      }
    });
  }

  void editWaitTask(WaitTask task) async {
    await showWaitTaskDialog(context: context, initialTask: task).then((data) {
      setState(() {
        if (data != null) {
          task.btnText = data.btnText;
        }
      });
    });
  }

  void mcqPrompt() async {
    await showMcqTaskDialog(context: context).then((data) {
      if (data != null) {
        _updateTaskList(data);
      }
    });
  }

  void editMcqPrompt(AddMcqTask task) async {
    await showMcqTaskDialog(context: context, initialTask: task).then((data) {
      setState(() {
        if (data != null) {
          task.isMultiSelect = data.isMultiSelect;
          task.arrangementType = data.arrangementType;
          task.options = data.options;
          task.correctOptionIndices = data.correctOptionIndices;
        }
      });
    });
  }

  void optionChainPrompt() async {
    await showOptionChainDialog(context: context).then((data) {
      if (data != null) {
        _updateTaskList(data);
      }
    });
  }

  Future<void> editOptionChain(AddOptionChainTask task) async {
    await showOptionChainDialog(context: context, initialTask: task)
        .then((data) {
      setState(() {
        if (data != null) {
          task.strikePrice = data.strikePrice;
          task.data = data.data;
          task.visibility = data.visibility;
          task.columns = data.columns;
          task.expiryDate = data.expiryDate;
          task.interval = data.interval;
          task.settings = data.settings;
        }
      });
    });
  }

  void showOptionChain() async {
    final highlightedDataTask =
        await showOptionChainById(context: context, tasks: tasks);
    if (highlightedDataTask != null) {
      _updateTaskList(highlightedDataTask);
    }
  }

  void showAddTab() async {
    final chooseTab = await addTabDialog(context: context, tasks: tasks);
    if (chooseTab != null) {
      _updateTaskList(chooseTab);
    }
  }

  void showAddChartTab() async {
    final chooseTab = await addChartTabDialog(
      context: context,
    );
    if (chooseTab != null) {
      final chartKey = GlobalKey<ChartState>();
      setState(() {
        _chartCandleData[chooseTab.id] = [];
        _chartTabs.add({
          'id': chooseTab.id,
          'title': chooseTab.tabTitle,
          'key': chartKey,
        });
        _activeChartTabIndex = _chartTabs.length - 1;
      });
      _updateTaskList(chooseTab);
    }
  }

  void editAddedTab(AddTabTask task) async {
    await editTabDialog(context: context, task: task).then((data) {
      setState(() {
        if (data != null) {
          task.tabTitle = data.tabTitle;
        }
      });
    });
  }

  void editAddedChartTab(AddChartTabTask task) async {
    await editChartTabDialog(context: context, task: task).then((data) {
      setState(() {
        if (data != null) {
          task.tabTitle = data.tabTitle;
          final tabIndex = _chartTabs.indexWhere((t) => t['id'] == task.id);
          if (tabIndex != -1) {
            _chartTabs[tabIndex]['title'] = data.tabTitle;
          }
        }
      });
    });
  }

  void showAllAddedTabs() async {
    final removeTab = await removeAddedTab(context: context, tasks: tasks);
    if (removeTab != null) {
      _updateTaskList(removeTab);
    }
  }

  void showPayoffGraphTemplate() async {
    final payOffData = await showOrEditPayOffGraphDialog(context: context);
    if (payOffData != null) {
      _updateTaskList(payOffData);
    }
  }

  Future<void> editHighlightedOptionChainData(
      ChooseCorrectOptionValueChainTask task) async {
    await showOptionChainById(
      context: context,
      tasks: tasks,
      initialTask: task,
    ).then((data) {
      setState(() {
        if (data != null) {
          task.taskId = data.taskId;
          task.maxSelectableRows = data.maxSelectableRows;
        }
      });
    });
  }

  Future<void> selectOptionChainToHighlight() async {
    final selectedOptionChain =
        await showAllOptionChains(context: context, tasks: tasks);
    if (selectedOptionChain != null) {
      _updateTaskList(selectedOptionChain);
    }
  }

  Future<AddPromptTask?> showPromptDialog({
    required BuildContext context,
    String title = 'Enter Text',
    String okButtonText = 'OK',
    String cancelButtonText = 'Cancel',
    AddPromptTask? initialTask,
    int? maxLines = 5,
    TextInputType keyboardType = TextInputType.multiline,
  }) async {
    final TextEditingController promptController =
        TextEditingController(text: initialTask?.promptText ?? '');
    final TextEditingController hintController =
        TextEditingController(text: initialTask?.hint ?? '');
    bool isExplanation = initialTask?.isExplanation ?? false;

    return showDialog<AddPromptTask>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MarkdownTextField(
                              controller: promptController,
                              hint: "Enter Prompt"),
                        )),
                    const SizedBox(height: 16),
                    Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MarkdownTextField(
                              controller: hintController, hint: "Enter Hint"),
                        )),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: isExplanation,
                          onChanged: (bool? value) {
                            setState(() {
                              isExplanation = value ?? false;
                            });
                          },
                        ),
                        const Text('Is Explanation'),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Returns null
                  },
                  child: Text(cancelButtonText),
                ),
                TextButton(
                  onPressed: () {
                    final promptText = promptController.text.trim();
                    final hintText = hintController.text.trim();
                    if (promptText.isNotEmpty) {
                      final task = AddPromptTask(
                        promptText: promptText,
                        isExplanation: isExplanation,
                        hint: hintText.isNotEmpty ? hintText : null,
                      );
                      Navigator.of(context).pop(task);
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(okButtonText),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<WaitTask?> showWaitTaskDialog({
    required BuildContext context,
    WaitTask? initialTask,
  }) {
    final TextEditingController textController = TextEditingController(
      text: initialTask?.btnText ?? 'Done',
    );

    final List<String> quickOptions = [
      'Done',
      'Understood',
      "Let's Go",
      "Okay",
      "Got it",
      "Next"
    ];

    return showDialog<WaitTask>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Button Text'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'Enter text for button',
                  border: OutlineInputBorder(),
                ),
                maxLines: 1,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    Navigator.of(context).pop(WaitTask(btnText: value));
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text('Quick Select:'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: quickOptions.map((option) {
                  return ActionChip(
                    label: Text(option),
                    onPressed: () {
                      textController.text = option;
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final text = textController.text.trim();
                if (text.isNotEmpty) {
                  Navigator.of(context).pop(WaitTask(btnText: text));
                } else {
                  // If empty, use default "Done"
                  Navigator.of(context).pop(WaitTask(btnText: 'Done'));
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<AddMcqTask?> showMcqTaskDialog({
    required BuildContext context,
    AddMcqTask? initialTask,
  }) async {
    // Initialize state based on initialTask or defaults
    bool isMultiSelect = initialTask?.isMultiSelect ?? false;
    MCQArrangementType arrangementType =
        initialTask?.arrangementType ?? MCQArrangementType.grid1x2;
    List<String> options =
        initialTask?.options != null && initialTask!.options.isNotEmpty
            ? List<String>.from(initialTask.options)
            : ['', ''];

    // Convert correctOptionIndices to selectedOptions boolean array
    List<bool> selectedOptions =
        List.generate(options.length, (index) => false);
    if (initialTask != null) {
      for (String index in initialTask.correctOptionIndices) {
        int idx = int.tryParse(index) ?? -1;
        if (idx >= 0 && idx < selectedOptions.length) {
          selectedOptions[idx] = true;
        }
      }
    }

    // Quick options for MCQ
    final List<String> quickOptions = [
      'True',
      'False',
      'Yes',
      'No',
      'Up',
      'Down',
      'Correct',
      'Incorrect',
      'All of the above',
      'None of the above'
    ];

    return showDialog<AddMcqTask>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Current selected option for quick option insertion
            int selectedOptionIndex = 0;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: 500,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: isMultiSelect,
                          onChanged: (value) {
                            setState(() {
                              isMultiSelect = value ?? false;

                              // If switching to single select and multiple options are selected,
                              // keep only the first selected option
                              if (!isMultiSelect &&
                                  selectedOptions.where((so) => so).length >
                                      1) {
                                int firstSelectedIndex =
                                    selectedOptions.indexOf(true);
                                for (int i = 0;
                                    i < selectedOptions.length;
                                    i++) {
                                  selectedOptions[i] =
                                      (i == firstSelectedIndex);
                                }
                              }
                            });
                          },
                        ),
                        const Text('Allow multiple selections'),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Arrangement type dropdown
                    Row(
                      children: [
                        const Text('Arrangement: '),
                        const SizedBox(width: 16),
                        DropdownButton<MCQArrangementType>(
                          value: arrangementType,
                          onChanged: (MCQArrangementType? newValue) {
                            if (newValue != null) {
                              setState(() {
                                arrangementType = newValue;
                              });
                            }
                          },
                          items: MCQArrangementType.values
                              .map((MCQArrangementType type) {
                            return DropdownMenuItem<MCQArrangementType>(
                              value: type,
                              child: Text(type.name),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Options',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),

                    // List of options
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final TextEditingController optionController =
                              TextEditingController(text: options[index]);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                // Checkbox for correct option
                                Checkbox(
                                  value: selectedOptions[index],
                                  onChanged: (value) {
                                    setState(() {
                                      if (isMultiSelect) {
                                        selectedOptions[index] = value ?? false;
                                      } else {
                                        // For single select, uncheck all others
                                        for (int i = 0;
                                            i < selectedOptions.length;
                                            i++) {
                                          selectedOptions[i] =
                                              i == index && (value ?? false);
                                        }
                                      }
                                    });
                                  },
                                ),

                                // Option text field
                                Expanded(
                                  child: TextField(
                                    controller: optionController,
                                    decoration: InputDecoration(
                                      hintText: 'Option ${index + 1}',
                                      border: const OutlineInputBorder(),
                                      // Add a small button to select this field for quick options
                                      suffixIcon: IconButton(
                                        icon: const Icon(
                                            Icons.add_circle_outline),
                                        tooltip: 'Apply quick option',
                                        onPressed: () {
                                          // Set the selected index for quick options
                                          selectedOptionIndex = index;
                                          // Show bottom sheet with quick options
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Quick Options for Option ${index + 1}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium,
                                                    ),
                                                    const SizedBox(height: 16),
                                                    Wrap(
                                                      spacing: 8,
                                                      runSpacing: 8,
                                                      children: quickOptions
                                                          .map((option) {
                                                        return ActionChip(
                                                          label: Text(option),
                                                          onPressed: () {
                                                            // Apply the selected quick option
                                                            setState(() {
                                                              options[selectedOptionIndex] =
                                                                  option;
                                                              optionController
                                                                      .text =
                                                                  option;
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    onChanged: (value) {
                                      options[index] = value;
                                    },
                                  ),
                                ),

                                // Remove option button
                                if (options.length > 2)
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        options.removeAt(index);
                                        selectedOptions.removeAt(index);
                                      });
                                    },
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Quick options section
                    const SizedBox(height: 16),
                    Text(
                      'Quick Options:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        // True/False preset
                        ActionChip(
                          label: const Text('Add True/False'),
                          onPressed: () {
                            setState(() {
                              options = ['True', 'False'];
                              selectedOptions = [false, false];
                            });
                          },
                        ),
                        // Yes/No preset
                        ActionChip(
                          label: const Text('Add Yes/No'),
                          onPressed: () {
                            setState(() {
                              options = ['Yes', 'No'];
                              selectedOptions = [false, false];
                            });
                          },
                        ),
                        // Up/Down preset
                        ActionChip(
                          label: const Text('Add Up/Down'),
                          onPressed: () {
                            setState(() {
                              options = ['Up', 'Down'];
                              selectedOptions = [false, false];
                            });
                          },
                        ),
                      ],
                    ),

                    // Add option button
                    TextButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Option'),
                      onPressed: () {
                        setState(() {
                          options.add('');
                          selectedOptions.add(false);
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Returns null
                          },
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Validate
                            if (!selectedOptions.contains(true)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please select at least one correct option')),
                              );
                              return;
                            }

                            if (options
                                .any((option) => option.trim().isEmpty)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Please fill in all options')),
                              );
                              return;
                            }

                            // Create list of correct option indices
                            List<String> correctOptionIndices = [];
                            for (int i = 0; i < selectedOptions.length; i++) {
                              if (selectedOptions[i]) {
                                correctOptionIndices.add(i.toString());
                              }
                            }

                            // Create the task (preserve original id if editing)
                            final task = initialTask != null
                                ? AddMcqTask(
                                    isMultiSelect: isMultiSelect,
                                    arrangementType: arrangementType,
                                    options: options,
                                    correctOptionIndices: correctOptionIndices,
                                  )
                                : AddMcqTask(
                                    isMultiSelect: isMultiSelect,
                                    arrangementType: arrangementType,
                                    options: options,
                                    correctOptionIndices: correctOptionIndices,
                                  );

                            Navigator.of(context).pop(task);
                          },
                          child:
                              Text(initialTask != null ? 'Update' : 'Create'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void editPayoffGraph(ShowPayOffGraphTask task) async {
    await showOrEditPayOffGraphDialog(context: context, task: task)
        .then((data) {
      setState(() {
        if (data != null) {
          task.quantity = data.quantity;
          task.spotPrice = data.spotPrice;
          task.spotPriceDayDelta = data.spotPriceDayDelta;
          task.spotPriceDayDeltaPer = data.spotPriceDayDeltaPer;
        }
      });
    });
  }

  void editMoveToTab(MoveTabTask task) async {
    await editMoveTabDialog(context: context, task: task, tasks: tasks)
        .then((data) {
      setState(() {
        if (data != null) {
          task.tabTaskID = data.tabTaskID;
        }
      });
    });
  }

  void moveToTab() async {
    final moveTab = await editMoveTabDialog(
      context: context,
      task: MoveTabTask(tabTaskID: ''),
      tasks: tasks,
    );
    if (moveTab != null) {
      _updateTaskList(moveTab);
    }
  }

  void showPopupTask() async {
    await showPopupDialog(context: context).then((data) {
      if (data != null) {
        _updateTaskList(data);
      }
    });
  }

  void editPopupTask(ShowPopupTask task) async {
    await showPopupDialog(context: context, initialTask: task).then((data) {
      setState(() {
        if (data != null) {
          task.title = data.title;
          task.description = data.description;
          task.buttonText = data.buttonText;
        }
      });
    });
  }

  void showBottomSheetTask() async {
    await showBottomSheetDialog(context: context).then((data) {
      if (data != null) {
        _updateTaskList(data);
      }
    });
  }

  void editBottomSheetTask(ShowBottomSheetTask task) async {
    await showBottomSheetDialog(context: context, initialTask: task)
        .then((data) {
      setState(() {
        if (data != null) {
          task.title = data.title;
          task.showImage = data.showImage;
          task.primaryButtonText = data.primaryButtonText;
          task.secondaryButtonText = data.secondaryButtonText;
        }
      });
    });
  }

  void showInsightsPageTask() async {
    await showInsightsPageDialog(context: context).then((data) {
      if (data != null) {
        _updateTaskList(data);
      }
    });
  }

  void editInsightsPageTask(ShowInsightsPageTask task) async {
    await showInsightsPageDialog(context: context, initialTask: task)
        .then((data) {
      setState(() {
        if (data != null) {
          task.title = data.title;
          task.description = data.description;
        }
      });
    });
  }

  void showInsightsPageV2Task() async {
    await showInsightsPageV2Dialog(context: context).then((data) {
      if (data != null) {
        _updateTaskList(data);
      }
    });
  }

  void editInsightsPageV2Task(ShowInsightsPageV2Task task) async {
    await showInsightsPageV2Dialog(context: context, initialTask: task)
        .then((data) {
      setState(() {
        if (data != null) {
          task.title = data.title;
          task.blocks = data.blocks;
        }
      });
    });
  }

  void _showShowToolsDialog() async {
    final result = await showShowToolsDialog(context: context);
    if (result != null) {
      _updateTaskList(result);
    }
  }

  void _editShowToolsDialog(ShowToolsTask task) async {
    final result =
        await showShowToolsDialog(context: context, initialTask: task);
    if (result != null) {
      setState(() {
        task.tools = result.tools;
      });
    }
  }

  List<SahiToolsModel> _buildCurrentTools() {
    final List<String> allToolNames = [];
    for (final indicator in IndicatorType.values) {
      allToolNames.add(indicator.name);
    }
    for (final layer in LayerType.values) {
      allToolNames.add(layer.name);
    }

    final Map<String, bool> visibility = {};
    final Map<String, bool> enabled = {};

    for (final t in tasks) {
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

  void _showToggleToolVisibilityDialog() async {
    final currentTools = _buildCurrentTools();
    final result = await showToggleToolVisibilityDialog(
      context: context,
      currentTools: currentTools,
    );
    if (result != null) {
      _updateTaskList(result);
    }
  }

  void _editToggleToolVisibilityDialog(ToggleToolVisibilityTask task) async {
    final currentTools = _buildCurrentTools();
    final result = await showToggleToolVisibilityDialog(
      context: context,
      initialTask: task,
      currentTools: currentTools,
    );
    if (result != null) {
      setState(() {
        task.visibility = result.visibility;
      });
    }
  }

  void _showAddRemoveToolsDialog() async {
    final currentTools = _buildCurrentTools();
    final result = await showAddRemoveToolsDialog(
      context: context,
      currentTools: currentTools,
    );
    if (result != null) {
      _updateTaskList(result);
    }
  }

  void _editAddRemoveToolsDialog(AddRemoveToolsTask task) async {
    final currentTools = _buildCurrentTools();
    final result = await showAddRemoveToolsDialog(
      context: context,
      initialTask: task,
      currentTools: currentTools,
    );
    if (result != null) {
      setState(() {
        task.enabled = result.enabled;
      });
    }
  }

  void _showOpenToolsPanelDialog() async {
    final result = await showOpenToolsPanelDialog(context: context);
    if (result != null) {
      _updateTaskList(result);
    }
  }

  void _editOpenToolsPanelDialog(OpenToolPanelTask task) async {
    final result =
        await showOpenToolsPanelDialog(context: context, initialTask: task);
    if (result != null) {
      setState(() {
        task.open = result.open;
        task.enabledTools.clear();
        task.enabledTools.addAll(result.enabledTools);
      });
    }
  }

  void showChooseBucketRows() async {
    final bucketRowsTask = await showChooseBucketRowsDialog(
      context: context,
      tasks: tasks,
    );
    if (bucketRowsTask != null) {
      _updateTaskList(bucketRowsTask);
    }
  }

  Future<void> editChooseBucketRows(ChooseBucketRowsTask task) async {
    await showChooseBucketRowsDialog(
      context: context,
      tasks: tasks,
      initialTask: task,
    ).then((data) {
      setState(() {
        if (data != null) {
          task.optionChainId = data.optionChainId;
          task.bucketRows = data.bucketRows;
          task.maxSelectableRows = data.maxSelectableRows;
        }
      });
    });
  }

  void showClearBucketRows() async {
    final clearBucketRowsTask = await showClearBucketRowsDialog(
      context: context,
      tasks: tasks,
    );
    if (clearBucketRowsTask != null) {
      _updateTaskList(clearBucketRowsTask);
    }
  }

  Future<void> editClearBucketRows(ClearBucketRowsTask task) async {
    await showClearBucketRowsDialog(
      context: context,
      tasks: tasks,
      initialTask: task,
    ).then((data) {
      setState(() {
        if (data != null) {
          task.optionChainId = data.optionChainId;
        }
      });
    });
  }

  void showTableTask() async {
    await showTableTaskDialog(context: context).then((data) {
      if (data != null) {
        _updateTaskList(data);
      }
    });
  }

  void editTableTask(TableTask task) async {
    await showTableTaskDialog(context: context, initialTask: task).then((data) {
      setState(() {
        if (data != null) {
          task.tables = data.tables;
        }
      });
    });
  }

  void highlightTableRowPrompt() async {
    final tableTasks = tasks.whereType<TableTask>().toList();
    if (tableTasks.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No TableTask found. Add a table first.')),
        );
      }
      return;
    }
    String tableTaskId = tableTasks.first.id;
    if (tableTasks.length > 1) {
      final selected = await showDialog<String>(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Select Table Task'),
            children: tableTasks
                .map((t) => SimpleDialogOption(
                      child: Text(t.tables.tables.first.tableTitle.isNotEmpty
                          ? t.tables.tables.first.tableTitle
                          : t.id),
                      onPressed: () => Navigator.pop(context, t.id),
                    ))
                .toList(),
          );
        },
      );
      if (selected == null) return;
      tableTaskId = selected;
    }
    final tableTask = tableTasks.firstWhere((t) => t.id == tableTaskId);
    final result = mounted
        ? await showHighlightTableRowDialog(
            context: context,
            tableTaskId: tableTaskId,
            tables: tableTask.tables.tables,
          )
        : null;

    if (result != null) {
      final selectedRows = result.map((k, v) => MapEntry(k, v.toList()));
      _updateTaskList(HighlightTableRowTask(
        tableTaskId: tableTaskId,
        selectedRows: selectedRows,
      ));
    }
  }

  void editHighlightTableRowTask(HighlightTableRowTask task) async {
    final tableTasks = tasks.whereType<TableTask>().toList();
    if (tableTasks.isEmpty) return;
    final tableTask = tableTasks.firstWhere((t) => t.id == task.tableTaskId,
        orElse: () => tableTasks.first);
    final initialSelection =
        task.selectedRows.map((k, v) => MapEntry(k, v.toSet()));
    final result = await showHighlightTableRowDialog(
      context: context,
      tableTaskId: tableTask.id,
      tables: tableTask.tables.tables,
      initialSelection: initialSelection,
    );
    if (result != null) {
      setState(() {
        task.selectedRows = result.map((k, v) => MapEntry(k, v.toList()));
      });
    }
  }

  Widget _buildChartTabBar() {
    if (_chartTabs.isEmpty) return const SizedBox.shrink();
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(50),
        border: Border(
          bottom: BorderSide(color: Colors.grey.withAlpha(100), width: 1),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _chartTabs.length,
        itemBuilder: (context, index) {
          final tab = _chartTabs[index];
          final isActive = index == _activeChartTabIndex;
          return GestureDetector(
            onTap: () {
              _activateChartTab(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isActive ? Colors.blue.withAlpha(50) : Colors.transparent,
                border: Border(
                  right:
                      BorderSide(color: Colors.grey.withAlpha(100), width: 1),
                  bottom: BorderSide(
                    color: isActive ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                tab['title'] ?? 'Chart ${index + 1}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive ? Colors.blue : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChartArea() {
    if (_chartTabs.isEmpty) {
      // No charts yet, show default chart
      if (widget.recipeStr == null) {
        return Chart(
          key: _chartKey,
          candles: candleData,
          onLayerSelect: _onLayerSelect,
          onRegionSelect: _onRegionSelect,
          onIndicatorSelect: _onIndicatorSelect,
          onInteraction: _onInteraction,
          chartType: _chartType,
          theme: Theme.of(context),
          onScannerResultSelect: (result) {
            setState(() {
              _selectedScannerResult = result;
              if (result != null) {
                selectedEvent = null;
              }
            });
          },
        );
      } else {
        return Chart.from(
            key: _chartKey,
            recipe: recipe!,
            onLayerSelect: _onLayerSelect,
            onRegionSelect: _onRegionSelect,
            onIndicatorSelect: _onIndicatorSelect,
            onInteraction: _onInteraction,
            theme: Theme.of(context));
      }
    }
    return Stack(
      children: _chartTabs.asMap().entries.map((entry) {
        final index = entry.key;
        final tab = entry.value;
        final chartKey = tab['key'] as GlobalKey<ChartState>;
        final tabId = tab['id'] as String;
        final tabCandleData = _chartCandleData[tabId] ?? [];
        return Offstage(
          offstage: index != _activeChartTabIndex,
          child: Chart(
            key: chartKey,
            candles: tabCandleData,
            onLayerSelect: (region, layer) {
              _activateChartTab(index);
              _onLayerSelect(region, layer);
            },
            onRegionSelect: (region) {
              _activateChartTab(index);
              _onRegionSelect(region);
            },
            onIndicatorSelect: (indicator) {
              _activateChartTab(index);
              _onIndicatorSelect(indicator);
            },
            onInteraction: (tapDownPoint, updatedPoint) {
              _activateChartTab(index);
              _onInteraction(tapDownPoint, updatedPoint);
            },
            chartType: _chartType,
            theme: Theme.of(context),
            onScannerResultSelect: (result) {
              _activateChartTab(index);
              setState(() {
                _selectedScannerResult = result;
                if (result != null) {
                  selectedEvent = null;
                }
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildToolBox() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.amber.withAlpha(100),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 20),
        reverse: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              iconSize: 30,
              tooltip: "Toggle Chart Type",
              icon: Icon(_chartType == ChartType.candlestick
                  ? Icons.candlestick_chart
                  : Icons.show_chart),
              onPressed: () {
                setState(() {
                  _chartType = _chartType == ChartType.candlestick
                      ? ChartType.line
                      : ChartType.candlestick;
                  _activeChartKey.currentState?.setChartType(_chartType);
                });
              },
            ),
            ElevatedButton(
              onPressed: _showAddEventDialog,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    isWaitingForEventPosition ? Colors.tealAccent : null),
              ),
              child: const Text("Add Event"),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
                onPressed: _showAddDataDialog, child: const Text("Add Data")),
            const SizedBox(width: 20),
            IndicatorTypeDropdown(
                selectedType: _selectedIndicatorType,
                onChanged: (indicatorType) {
                  _addIndicator(indicatorType);
                }),
            const SizedBox(width: 20),
            LayerTypeDropdown(
                selectedType: _selectedLayerType,
                onChanged: (layerType) {
                  setState(() {
                    _selectedLayerType = layerType;
                    _activeChartKey.currentState
                        ?.updateLayerGettingAddedState(layerType);
                  });
                })
          ],
        ),
      ),
    );
  }

  void _showAddDataDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddDataDialog(onDataUpdate: (data) {
            setState(() {
              if (_chartTabs.isNotEmpty &&
                  _activeChartTabIndex >= 0 &&
                  _activeChartTabIndex < _chartTabs.length) {
                final activeId =
                    _chartTabs[_activeChartTabIndex]['id'] as String;
                _chartCandleData[activeId] = [
                  ...(_chartCandleData[activeId] ?? []),
                  ...data,
                ];
                candleData = _buildFlattenedCandleDataForSave();
              } else {
                candleData.addAll(data);
              }
            });
            _activeChartKey.currentState?.addData(data);
          });
        });
  }

  void _showAddEventDialog() {
    setState(() {
      // Enable waiting mode in chart
      isWaitingForEventPosition = true;
      _activeChartKey.currentState?.isWaitingForEventPosition = true;
    });
  }

  void _addIndicator(IndicatorType indicatorType) {
    final chartState = _activeChartKey.currentState;
    if (chartState == null) {
      return;
    }

    final currentChartId = _currentChartId();

    Indicator? indicator;
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
        indicator = Pe(getFundamentalEvents: _activeChartFundamentalEvents);
        break;
      case IndicatorType.pb:
        indicator = Pb(getFundamentalEvents: _activeChartFundamentalEvents);
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
    chartState.addIndicator(indicator);
    if (_currentTaskType == TaskType.addIndicator) {
      _updateTaskList(AddIndicatorTask(
        indicator: indicator,
        chartId: currentChartId,
      ));
    }
  }

  @override
  void dispose() {
    // Cancel timer when widget is disposed
    _autosaveTimer?.cancel();
    super.dispose();
  }
}
