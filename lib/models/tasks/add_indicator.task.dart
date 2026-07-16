import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/task_type.dart';

class AddIndicatorTask extends Task {
  final Indicator indicator;
  final String? chartId;

  AddIndicatorTask({required this.indicator, this.chartId})
      : super(
            id: generateV4(),
            actionType: ActionType.empty,
            taskType: TaskType.addIndicator);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['indicator'] = indicator.toJson();
    data['chartId'] = chartId;
    return data;
  }

  factory AddIndicatorTask.fromJson(Map<String, dynamic> json) {
    return AddIndicatorTask(
      indicator: Indicator.fromJson(json: json['indicator']),
      chartId: json['chartId'],
    );
  }
}
