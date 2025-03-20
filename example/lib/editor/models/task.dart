import 'package:example/editor/models/add_data.task.dart';
import 'package:example/editor/models/add_layer.task.dart';
import 'package:example/editor/models/add_prompt.task.dart';
import 'package:example/editor/models/add_region.task.dart';
import 'package:example/editor/models/enums/action_type.dart';
import 'package:example/editor/models/enums/task_type.dart';
import 'package:example/editor/models/wait.task.dart';

abstract class Task {
  final String id;
  final ActionType actionType;
  final TaskType taskType;

  Task({required this.id, required this.actionType, required this.taskType});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'actionType': actionType.name,
      'taskType': taskType.name,
    };
  }

  static Task fromJson(Map<String, dynamic> json) {
    final taskType = json['taskType'];

    switch (taskType) {
      case 'addData':
        return AddDataTask.fromJson(json);
      case 'addLayer':
        return AddLayerTask.fromJson(json);
      case 'addPrompt':
        return AddPromptTask.fromJson(json);
      case 'addRegion':
        return AddRegionTask.fromJson(json);
      case 'waitTask':
        return WaitTask.fromJson(json);
      default:
        throw ArgumentError('Unknown task type: $taskType');
    }
  }
}


  //Map<String, dynamic> toJson();