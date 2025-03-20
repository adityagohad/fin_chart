import 'package:example/editor/models/task.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:example/editor/models/enums/action_type.dart';
import 'package:example/editor/models/enums/task_type.dart';

class AddPromptTask extends Task {
  String promptText;
  AddPromptTask({required this.promptText})
      : super(
            id: generateV4(),
            actionType: ActionType.empty,
            taskType: TaskType.addPrompt);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['promptText'] = promptText;
    return data;
  }

  factory AddPromptTask.fromJson(Map<String, dynamic> json) {
    return AddPromptTask(
      promptText: json['promptText'],
    );
  }
}
