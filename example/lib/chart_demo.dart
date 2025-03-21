import 'dart:convert';

import 'package:example/editor/models/add_data.task.dart';
import 'package:example/editor/models/add_layer.task.dart';
import 'package:example/editor/models/add_prompt.task.dart';
import 'package:example/editor/models/add_region.task.dart';
import 'package:example/editor/models/enums/action_type.dart';
import 'package:example/editor/models/enums/task_type.dart';
import 'package:example/editor/models/recipe.dart';
import 'package:example/editor/models/task.dart';
import 'package:example/editor/models/wait.task.dart';
import 'package:fin_chart/fin_chart.dart';
import 'package:fin_chart/models/settings/x_axis_settings.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';
import 'package:flutter/material.dart';

class ChartDemo extends StatefulWidget {
  final String recipeDataJson;
  const ChartDemo({super.key, required this.recipeDataJson});

  @override
  State<ChartDemo> createState() => _ChartDemoState();
}

class _ChartDemoState extends State<ChartDemo> {
  final GlobalKey<ChartState> _chartKey = GlobalKey();
  late Recipe recipe;

  int taskPointer = 0;
  late Task currentTask;

  String promptText = "";

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
        _chartKey.currentState
            ?.addData(recipe.data.sublist(task.fromPoint, task.tillPoint));
        break;
      case TaskType.addRegion:
        AddRegionTask task = currentTask as AddRegionTask;
        _chartKey.currentState?.addRegion(task.region);
        break;
      case TaskType.addLayer:
        AddLayerTask task = currentTask as AddLayerTask;
        _chartKey.currentState?.addLayerAtRegion(task.regionId, task.layer);
        break;
      case TaskType.addPrompt:
        AddPromptTask task = currentTask as AddPromptTask;
        setState(() {
          promptText = task.promptText;
        });
        break;
      case TaskType.waitTask:
        setState(() {});
        break;
    }
    if (currentTask.actionType == ActionType.empty) {
      onTaskFinish();
    }
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
          Flexible(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(promptText),
            ),
          ),
          Flexible(
              flex: 8,
              child: Chart(
                  key: _chartKey,
                  yAxisSettings: const YAxisSettings(yAxisPos: YAxisPos.right),
                  xAxisSettings: const XAxisSettings(xAxisPos: XAxisPos.bottom),
                  candles: const [],
                  onInteraction: (p0, p1) {})),
          Flexible(
            flex: 1,
            child: currentTask.actionType == ActionType.interupt
                ? ElevatedButton(
                    onPressed: () {
                      onTaskFinish();
                    },
                    child: Text((currentTask as WaitTask).btnText))
                : Container(),
          )
        ],
      )),
    );
  }
}
