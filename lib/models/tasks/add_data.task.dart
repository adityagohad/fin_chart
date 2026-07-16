import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/utils/calculations.dart';

class AddDataTask extends Task {
  final String verticleLineId;
  final String? chartId;
  int fromPoint;
  int tillPoint;

  AddDataTask(
      {required this.verticleLineId,
      this.chartId,
      required this.fromPoint,
      required this.tillPoint})
      : super(
            id: generateV4(),
            actionType: ActionType.empty,
            taskType: TaskType.addData);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['verticleLineId'] = verticleLineId;
    data['chartId'] = chartId;
    data['fromPoint'] = fromPoint;
    data['tillPoint'] = tillPoint;
    return data;
  }

  factory AddDataTask.fromJson(Map<String, dynamic> json) {
    return AddDataTask(
        verticleLineId: json['verticleLineId'] ?? "",
        chartId: json['chartId'],
        fromPoint: json['fromPoint'],
        tillPoint: json['tillPoint']);
  }
}
