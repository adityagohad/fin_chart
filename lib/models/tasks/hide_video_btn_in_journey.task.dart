import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/utils/calculations.dart';

class HideVideoBtnInJourneyTask extends Task {
  String journeyId;

  HideVideoBtnInJourneyTask({this.journeyId = ''})
      : super(
          id: generateV4(),
          actionType: ActionType.empty,
          taskType: TaskType.hideVideoBtnInJourney,
        );

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['journeyId'] = journeyId;
    return data;
  }

  factory HideVideoBtnInJourneyTask.fromJson(Map<String, dynamic> json) {
    return HideVideoBtnInJourneyTask(
      journeyId: json['journeyId'] ?? '',
    );
  }
}
