import 'package:example/editor/models/enums/action_type.dart';
import 'package:example/editor/models/enums/task_type.dart';
import 'package:example/editor/models/task.dart';
import 'package:fin_chart/utils/calculations.dart';

class AddDataTask extends Task {
  int atPoint;
  AddDataTask({
    required this.atPoint,
  }) : super(
            id: generateV4(),
            actionType: ActionType.empty,
            taskType: TaskType.addData);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['atPoint'] = atPoint;
    return data;
  }

  factory AddDataTask.fromJson(Map<String, dynamic> json) {
    return AddDataTask(
      atPoint: json['atPoint'],
    );
  }
}
