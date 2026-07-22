import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/utils/calculations.dart';

class CompleteJourneyTask extends Task {
  CompleteJourneyTask()
      : super(
            id: generateV4(),
            actionType: ActionType.empty,
            taskType: TaskType.completeJourney);

  factory CompleteJourneyTask.fromJson(Map<String, dynamic> json) {
    return CompleteJourneyTask();
  }
}
