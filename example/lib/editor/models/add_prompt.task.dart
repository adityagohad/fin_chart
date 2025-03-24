import 'package:example/editor/models/task.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:example/editor/models/enums/action_type.dart';
import 'package:example/editor/models/enums/task_type.dart';

class AddPromptTask extends Task {
  String promptText;
  bool isExplanation;
  AddPromptTask({required this.promptText, this.isExplanation = false})
      : super(
            id: generateV4(),
            actionType: ActionType.empty,
            taskType: TaskType.addPrompt);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['promptText'] = promptText;
    data['isExplanation'] = isExplanation;
    return data;
  }

  factory AddPromptTask.fromJson(Map<String, dynamic> json) {
    return AddPromptTask(
        promptText: json['promptText'], isExplanation: json['isExplanation']);
  }
}
