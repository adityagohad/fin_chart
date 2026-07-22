import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/utils/calculations.dart';

class AddCourseVideoTask extends Task {
  String videoUrl;
  String title;

  AddCourseVideoTask({
    required this.videoUrl,
    required this.title,
  }) : super(
          id: generateV4(),
          actionType: ActionType.empty,
          taskType: TaskType.addCourseVideo,
        );

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['videoUrl'] = videoUrl;
    data['title'] = title;
    return data;
  }

  factory AddCourseVideoTask.fromJson(Map<String, dynamic> json) {
    return AddCourseVideoTask(
      videoUrl: json['videoUrl'],
      title: json['title'],
    );
  }
}
