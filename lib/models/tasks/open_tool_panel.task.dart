import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/utils/calculations.dart';

class OpenToolPanelTask extends Task {
  bool open;
  Map<String, bool> enabledTools;

  OpenToolPanelTask({
    required this.open,
    this.enabledTools = const {},
  }) : super(
          id: generateV4(),
          actionType: ActionType.empty,
          taskType: TaskType.openToolPanel,
        );

  bool isToolEnabled(String toolName) => enabledTools[toolName] ?? true;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['open'] = open;
    data['enabledTools'] = enabledTools;
    return data;
  }

  factory OpenToolPanelTask.fromJson(Map<String, dynamic> json) {
    final rawTools = json['enabledTools'];
    Map<String, bool> tools = {};
    if (rawTools is Map) {
      rawTools.forEach((key, value) {
        tools[key.toString()] = value == true;
      });
    }
    return OpenToolPanelTask(
      open: json['open'] ?? false,
      enabledTools: tools,
    );
  }
}
