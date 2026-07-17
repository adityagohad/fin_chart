import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/utils/calculations.dart';

class AddRemoveToolsTask extends Task {
  Map<String, bool> enabled;

  AddRemoveToolsTask({this.enabled = const {}})
      : super(
          id: generateV4(),
          actionType: ActionType.empty,
          taskType: TaskType.addRemoveTools,
        );

  bool isToolEnabled(String toolName) => enabled[toolName] ?? false;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['enabled'] = enabled;
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
    return AddRemoveToolsTask(enabled: tools);
  }
}
