import 'package:example/editor/models/task.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:example/editor/models/enums/action_type.dart';
import 'package:example/editor/models/enums/task_type.dart';

class AddRegionTask extends Task {
  final PlotRegion region;
  AddRegionTask({required this.region})
      : super(
            id: generateV4(),
            actionType: ActionType.empty,
            taskType: TaskType.addRegion);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['region'] = region.toJson();
    return data;
  }

  factory AddRegionTask.fromJson(Map<String, dynamic> json) {
    return AddRegionTask(
      region: PlotRegion.fromJson(json['region']),
    );
  }
}
