import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/utils/calculations.dart';

class AddRemoveToolsTask extends Task {
  Map<String, bool> enabled;
  Map<String, Map<String, dynamic>> toolConfigs;

  AddRemoveToolsTask({
    this.enabled = const {},
    this.toolConfigs = const {},
  }) : super(
          id: generateV4(),
          actionType: ActionType.empty,
          taskType: TaskType.addRemoveTools,
        );

  bool isToolEnabled(String toolName) => enabled[toolName] ?? false;

  Map<String, dynamic>? getToolConfig(String toolName) => toolConfigs[toolName];

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['enabled'] = enabled;
    data['toolConfigs'] = toolConfigs;
    return data;
  }

  factory AddRemoveToolsTask.fromJson(Map<String, dynamic> json) {
    final rawEnabled = json['enabled'];
    Map<String, bool> tools = {};
    if (rawEnabled is Map) {
      rawEnabled.forEach((key, value) {
        tools[key.toString()] = value == true;
      });
    }

    final rawConfigs = json['toolConfigs'];
    Map<String, Map<String, dynamic>> configs = {};
    if (rawConfigs is Map) {
      rawConfigs.forEach((key, value) {
        if (value is Map) {
          configs[key.toString()] = Map<String, dynamic>.from(value);
        }
      });
    }

    return AddRemoveToolsTask(enabled: tools, toolConfigs: configs);
  }
}
