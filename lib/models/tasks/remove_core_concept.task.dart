import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/utils/calculations.dart';

class RemoveCoreConceptTask extends Task {
  RemoveCoreConceptTask()
      : super(
            id: generateV4(),
            actionType: ActionType.empty,
            taskType: TaskType.removeCoreConcept);

  factory RemoveCoreConceptTask.fromJson(Map<String, dynamic> json) {
    return RemoveCoreConceptTask();
  }
}
