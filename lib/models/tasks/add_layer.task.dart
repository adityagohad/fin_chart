import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/utils/calculations.dart';

class AddLayerTask extends Task {
  final String regionId;
  final Layer layer;
  final String? chartId;
  AddLayerTask({
    required this.regionId,
    required this.layer,
    this.chartId,
  }) : super(
            id: generateV4(),
            actionType: ActionType.empty,
            taskType: TaskType.addLayer);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['layer'] = layer.toJson();
    data['regionId'] = regionId;
    data['chartId'] = chartId;
    return data;
  }

  factory AddLayerTask.fromJson(Map<String, dynamic> json) {
    return AddLayerTask(
      layer: Layer.fromJson(json: json['layer']),
      regionId: json['regionId'],
      chartId: json['chartId'],
    );
  }
}
