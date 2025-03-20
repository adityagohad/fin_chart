import 'package:example/editor/models/task.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:example/editor/models/enums/action_type.dart';
import 'package:example/editor/models/enums/task_type.dart';

class AddLayerOfTypeTask extends Task {
  AddLayerOfTypeTask()
      : super(
            id: generateV4(),
            actionType: ActionType.interupt,
            taskType: TaskType.addLayerOfType);
}
