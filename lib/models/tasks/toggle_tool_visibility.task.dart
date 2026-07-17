import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/utils/calculations.dart';

class ToggleToolVisibilityTask extends Task {
  Map<String, bool> visibility;

  ToggleToolVisibilityTask({this.visibility = const {}})
      : super(
          id: generateV4(),
          actionType: ActionType.empty,
          taskType: TaskType.toggleToolVisibility,
        );

  bool isToolVisible(String toolName) => visibility[toolName] ?? false;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['visibility'] = visibility;
    return data;
  }

  factory ToggleToolVisibilityTask.fromJson(Map<String, dynamic> json) {
    final rawVisibility = json['visibility'];
    Map<String, bool> vis = {};
    if (rawVisibility is Map) {
      rawVisibility.forEach((key, value) {
        vis[key.toString()] = value == true;
      });
    }
    return ToggleToolVisibilityTask(visibility: vis);
  }
}
