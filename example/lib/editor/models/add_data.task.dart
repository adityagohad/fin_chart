import 'package:example/editor/models/enums/action_type.dart';
import 'package:example/editor/models/enums/task_type.dart';
import 'package:example/editor/models/task.dart';
import 'package:fin_chart/utils/calculations.dart';

class AddDataTask extends Task {
  final String verticleLineId;
  final int fromPoint;
  final int tillPoint;

  AddDataTask(
      {required this.verticleLineId,
      required this.fromPoint,
      required this.tillPoint})
      : super(
            id: generateV4(),
            actionType: ActionType.empty,
            taskType: TaskType.addData);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['fromPoint'] = fromPoint;
    data['tillPoint'] = tillPoint;
    return data;
  }

  factory AddDataTask.fromJson(Map<String, dynamic> json) {
    return AddDataTask(
        verticleLineId: "",
        fromPoint: json['fromPoint'],
        tillPoint: json['tillPoint']);
  }
}
