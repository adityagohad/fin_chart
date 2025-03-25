import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/task_type.dart';

class AddIndicatorTask extends Task {
  final Indicator indicator;
  AddIndicatorTask({required this.indicator})
      : super(
            id: generateV4(),
            actionType: ActionType.empty,
            taskType: TaskType.addIndicator);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['indicator'] = indicator.toJson();
    return data;
  }

  factory AddIndicatorTask.fromJson(Map<String, dynamic> json) {
    return AddIndicatorTask(
      indicator: Indicator.fromJson(json: json['indicator']),
    );
  }
}
