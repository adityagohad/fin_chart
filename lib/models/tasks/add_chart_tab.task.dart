import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/utils/calculations.dart';

class AddChartTabTask extends Task {
  String tabTitle;
  int fromPoint;
  int tillPoint;

  AddChartTabTask({
    String? id,
    required this.tabTitle,
    this.fromPoint = 0,
    this.tillPoint = -1,
  }) : super(
          id: id ?? generateV4(),
          actionType: ActionType.empty,
          taskType: TaskType.addChartTab,
        );

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['tabTitle'] = tabTitle;
    data['fromPoint'] = fromPoint;
    data['tillPoint'] = tillPoint;
    return data;
  }

  factory AddChartTabTask.fromJson(Map<String, dynamic> json) {
    return AddChartTabTask(
      id: json['id'],
      tabTitle: json['tabTitle'],
      fromPoint: json['fromPoint'] ?? 0,
      tillPoint: json['tillPoint'] ?? -1,
    );
  }
}
