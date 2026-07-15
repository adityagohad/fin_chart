import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/sahi_tools_model.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/utils/calculations.dart';

class ShowToolsTask extends Task {
  List<SahiToolsModel> tools;

  ShowToolsTask({this.tools = const []})
      : super(
          id: generateV4(),
          actionType: ActionType.empty,
          taskType: TaskType.showTools,
        );

  SahiToolsModel? getTool(String title) {
    for (final tool in tools) {
      if (tool.title == title) return tool;
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['tools'] = tools.map((t) => t.toJson()).toList();
    return data;
  }

  factory ShowToolsTask.fromJson(Map<String, dynamic> json) {
    final rawTools = json['tools'];
    List<SahiToolsModel> parsed = [];
    if (rawTools is List) {
      for (final item in rawTools) {
        if (item is Map<String, dynamic>) {
          parsed.add(SahiToolsModel.fromJson(item));
        }
      }
    }
    return ShowToolsTask(tools: parsed);
  }
}
