import 'dart:convert';
import 'dart:developer';

import 'package:example/chart_demo.dart';
import 'package:example/dialog/add_data_dialog.dart';
import 'package:example/editor/models/add_data.task.dart';
import 'package:example/editor/models/add_layer_of_type.task.dart';
import 'package:example/editor/models/add_layer.task.dart';
import 'package:example/editor/models/add_region.task.dart';
import 'package:example/editor/models/enums/task_type.dart';
import 'package:example/editor/models/add_prompt.task.dart';
import 'package:example/editor/models/recipe.dart';
import 'package:example/editor/models/task.dart';
import 'package:example/editor/models/wait.task.dart';
import 'package:example/widget/layer_type_dropdown.dart';
import 'package:example/widget/task_list_widget.dart';
import 'package:fin_chart/chart.dart';
import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/layers/circular_area.dart';
import 'package:fin_chart/models/layers/horizontal_band.dart';
import 'package:fin_chart/models/layers/horizontal_line.dart';
import 'package:fin_chart/models/layers/label.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/models/layers/rect_area.dart';
import 'package:fin_chart/models/layers/trend_line.dart';
import 'package:fin_chart/models/layers/vertical_line.dart';
import 'package:fin_chart/models/region/dummy_plot_region.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/models/region/rsi_plot_region.dart';
import 'package:fin_chart/models/settings/x_axis_settings.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';
import 'package:fin_chart/ui/region_dialog.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:flutter/material.dart';
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/region/macd_plot_region.dart';
import 'package:fin_chart/models/region/stochastic_plot_region.dart';
import 'package:fin_chart/models/enums/plot_region_type.dart';
import 'package:fin_chart/models/region/main_plot_region.dart';
import 'package:fin_chart/models/layers/arrow.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ChartState> _chartKey = GlobalKey();
  List<ICandle> candleData = [];
  List<PlotRegion> regions = [];
  LayerType? _selectedType;

  List<Offset> drawPoints = [];
  Offset startingPoint = Offset.zero;

  List<Task> tasks = [];

  TaskType? currentType;

  void prompt() async {
    await showPromptDialog(context: context).then((data) {
      setState(() {
        if (data != null) {
          tasks.add(AddPromptTask(promptText: data));
        }
        currentType = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Finance Charts"),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChartDemo(
                          recipeDataJson: jsonEncode(
                              Recipe(data: candleData, tasks: tasks).toJson())),
                    ));
              },
              child: const Text("Preview")),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () {
                String copy = jsonEncode(_chartKey.currentState?.toJson());
                Recipe recipe = Recipe(data: candleData, tasks: tasks);
                copy = jsonEncode(recipe.toJson());
                log(copy);
                Clipboard.setData(ClipboardData(text: copy)).then((_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("$copy to clipboar")));
                  }
                });
              },
              child: const Text("export"))
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
                // child: ElevatedButton(
                //     onPressed: () {
                //       _chartKey.currentState
                //           ?.addRegion(RsiPlotRegion.fromJson(region));
                //     },
                //     child: Text("Add Region")),
                padding: const EdgeInsets.all(10),
                child: TaskListWidget(
                  task: tasks,
                  onTaskAdd: (p0) {
                    setState(() {
                      switch (p0) {
                        case TaskType.addRegion:
                        case TaskType.addLayer:
                          currentType = p0;
                          break;
                        case TaskType.addData:
                          currentType = p0;
                          break;
                        case TaskType.addPrompt:
                          prompt();
                          break;
                        case TaskType.addLayerOfType:
                          tasks.add(AddLayerOfTypeTask());
                          currentType = null;
                          break;
                        case TaskType.waitTask:
                          tasks.add(WaitTask(btnText: "Next"));
                          currentType = null;
                          break;
                      }
                    });
                  },
                  onClick: (p0) {
                    if (p0.taskType == TaskType.addRegion) {
                      _chartKey.currentState
                          ?.addRegion((p0 as AddRegionTask).region);
                    } else if (p0.taskType == TaskType.addLayer) {
                      AddLayerTask task = p0 as AddLayerTask;
                      _chartKey.currentState
                          ?.addLayerAtRegion(task.regionId, task.layer);
                    } else if (p0.taskType == TaskType.addData) {
                    } else if (p0.taskType == TaskType.addPrompt) {}
                  },
                  onDelete: (task) {
                    setState(() {
                      tasks.removeWhere((t) => t == task); // Remove the task
                    });
                  },
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }

                      if (newIndex >= tasks.length) {
                        return;
                      }

                      final Task item = tasks.removeAt(oldIndex);
                      tasks.insert(newIndex, item);
                    });
                  },
                )
                // Container(
                //   padding: const EdgeInsets.all(10),
                //   width: double.infinity,
                //   decoration: const BoxDecoration(
                //     color: Colors.grey,
                //     borderRadius: BorderRadius.all(Radius.circular(10)),
                //   ),
                //   child: const Text("Hey prompt text goes here"),
                // ),
                ),
          ),
          Expanded(
            flex: 8,
            child: Chart(
              key: _chartKey,
              yAxisSettings: const YAxisSettings(yAxisPos: YAxisPos.right),
              xAxisSettings: const XAxisSettings(xAxisPos: XAxisPos.bottom),
              candles: candleData,
              regions: regions,
              onLayerSelect: (region, layer) {
                if (currentType == TaskType.addLayer) {
                  setState(() {
                    tasks.add(AddLayerTask(layer: layer, regionId: region.id));
                    currentType = null;
                  });
                }
                if (currentType == TaskType.addData &&
                    layer.runtimeType == VerticalLine) {
                  setState(() {
                    tasks.add(AddDataTask(
                        atPoint: (layer as VerticalLine).pos.round()));
                    currentType = null;
                  });
                }
              },
              onRegionSelect: (region) {
                if (currentType == TaskType.addRegion) {
                  setState(() {
                    tasks.add(AddRegionTask(region: region));
                    currentType = null;
                  });
                }
                // print(jsonEncode(region.toJson()));
              },
              onInteraction: (p0, p1) {
                if (_selectedType != null) {
                  drawPoints.add(p0);
                  startingPoint = p1;
                  Layer? layer;
                  switch (_selectedType) {
                    case LayerType.label:
                      layer = Label.fromTool(
                          pos: drawPoints.first,
                          label: "Text is long\nand has line breaks",
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
                      layer =
                          HorizontalLine.fromTool(value: drawPoints.first.dy);
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
                            startPoint: startingPoint);
                      } else {
                        layer = null;
                      }
                      break;
                    case LayerType.circularArea:
                      layer = CircularArea.fromTool(point: drawPoints.first);
                      break;
                    case LayerType.arrow:
                      layer = Arrow.fromTool(
                          from: drawPoints.first,
                          to: drawPoints.last,
                          startPoint: startingPoint);
                      break;
                    case LayerType.verticalLine:
                      layer = VerticalLine.fromTool(pos: p0.dx);
                      break;
                    case null:
                      layer = null;
                      break;
                  }
                  setState(() {
                    if (layer != null) {
                      _selectedType = null;
                      drawPoints.clear();
                      _chartKey.currentState?.addLayer(layer);
                    }
                  });
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: _showAddDataDialog,
                      child: const Text("Add Data")),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return RegionDialog(
                              onSubmit: (type, variety, yMin, yMax) {
                                if (type == PlotRegionType.indicator) {
                                  if (variety == 'RSI') {
                                    _chartKey.currentState
                                        ?.addRegion(RsiPlotRegion(
                                      id: generateV4(),
                                      type: type,
                                      yAxisSettings: const YAxisSettings(
                                          yAxisPos: YAxisPos.right),
                                      candles: [],
                                    ));
                                  } else if (variety == 'MACD') {
                                    // Add MACD region with custom min/max values
                                    _chartKey.currentState
                                        ?.addRegion(MACDPlotRegion(
                                      id: generateV4(),
                                      candles: [],
                                      type: type,
                                      yAxisSettings: const YAxisSettings(
                                          yAxisPos: YAxisPos.right),
                                    ));
                                  } else if (variety == 'Stochastic') {
                                    // Add Stochastic region with fixed 0-100 bounds
                                    _chartKey.currentState
                                        ?.addRegion(StochasticPlotRegion(
                                      id: generateV4(),
                                      candles: [],
                                      type: type,
                                      yAxisSettings: const YAxisSettings(
                                          yAxisPos: YAxisPos.right),
                                    ));
                                  }
                                } else if (type == PlotRegionType.data) {
                                  if (variety == 'Candle') {
                                    _chartKey.currentState
                                        ?.addRegion(MainPlotRegion(
                                      id: generateV4(),
                                      candles: [],
                                      type: type,
                                      yAxisSettings: const YAxisSettings(
                                          yAxisPos: YAxisPos.right),
                                    ));
                                  } else if (variety == 'Line') {
                                    // Add line chart region
                                    _chartKey.currentState
                                        ?.addRegion(DummyPlotRegion(
                                      id: generateV4(),
                                      candles: [],
                                      type: type,
                                      yAxisSettings: const YAxisSettings(
                                          yAxisPos: YAxisPos.right),
                                    ));
                                  }
                                }
                              },
                            );
                          });
                    },
                    child: const Text("Add Region"),
                  ),
                  LayerTypeDropdown(
                      selectedType: _selectedType,
                      onChanged: (layerType) {
                        setState(() {
                          _selectedType = layerType;
                          _chartKey.currentState
                              ?.updateLayerGettingAddedState(layerType);
                        });
                      })
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  void _showAddDataDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddDataDialog(onDataUpdate: (data) {
            setState(() {
              // Update the local candleData list
              candleData.addAll(data);
            });
            // Then update the chart
            _chartKey.currentState?.addData(data);
          });
        });
  }

  Future<String?> showPromptDialog({
    required BuildContext context,
    String title = 'Enter Text',
    String hintText = 'Enter your text here',
    String initialText = '',
    String okButtonText = 'OK',
    String cancelButtonText = 'Cancel',
    int? maxLines,
    TextInputType keyboardType = TextInputType.multiline,
  }) async {
    final TextEditingController textController =
        TextEditingController(text: initialText);

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop(); // Returns null
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(textController.text); // Returns the entered text
                  },
                  child: Text(okButtonText),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: const OutlineInputBorder(),
                  filled: true,
                ),
                maxLines: maxLines, // null means unlimited lines
                keyboardType: keyboardType,
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
              ),
            ),
          ),
        );
      },
    );
  }
}
