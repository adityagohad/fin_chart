import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/utils/calculations.dart';

class StartJourneyTask extends Task {
  String journeyId;

  StartJourneyTask({String? journeyId})
      : journeyId = journeyId ?? generateV4(),
        super(
          id: generateV4(),
          actionType: ActionType.empty,
          taskType: TaskType.startJourney,
        );

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['journeyId'] = journeyId;
    return data;
  }

  factory StartJourneyTask.fromJson(Map<String, dynamic> json) {
    return StartJourneyTask(
      journeyId: json['journeyId'],
    );
  }
}
