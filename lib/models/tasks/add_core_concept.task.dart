import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/utils/calculations.dart';

class AddCoreConceptTask extends Task {
  String title;
  String description;

  AddCoreConceptTask({
    required this.title,
    required this.description,
    String? id,
  }) : super(
          id: id ?? generateV4(),
          actionType: ActionType.interupt,
          taskType: TaskType.addCoreConcept,
        );

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['title'] = title;
    data['description'] = description;
    return data;
  }

  factory AddCoreConceptTask.fromJson(Map<String, dynamic> json) {
    return AddCoreConceptTask(
      title: json['title'],
      description: json['description'],
      id: json['id'],
    );
  }
}
