import 'package:example/editor/models/task.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:example/editor/models/enums/action_type.dart';
import 'package:example/editor/models/enums/task_type.dart';

class WaitTask extends Task {
  String btnText;
  WaitTask({required this.btnText})
      : super(
            id: generateV4(),
            actionType: ActionType.interupt,
            taskType: TaskType.waitTask);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['btnText'] = btnText;
    return data;
  }

  factory WaitTask.fromJson(Map<String, dynamic> json) {
    return WaitTask(
      btnText: json['btnText'],
    );
  }
}
