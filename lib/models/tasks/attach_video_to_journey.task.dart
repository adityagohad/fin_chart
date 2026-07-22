import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/utils/calculations.dart';

class AttachVideoToJourneyTask extends Task {
  String journeyId;
  String videoUrl;

  AttachVideoToJourneyTask({
    this.journeyId = '',
    required this.videoUrl,
  }) : super(
          id: generateV4(),
          actionType: ActionType.empty,
          taskType: TaskType.attachVideoToJourney,
        );

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['journeyId'] = journeyId;
    data['videoUrl'] = videoUrl;
    return data;
  }

  factory AttachVideoToJourneyTask.fromJson(Map<String, dynamic> json) {
    return AttachVideoToJourneyTask(
      journeyId: json['journeyId'] ?? '',
      videoUrl: json['videoUrl'],
    );
  }
}
