import 'package:example/editor/models/enums/action_type.dart';
import 'package:example/editor/models/enums/task_type.dart';
import 'package:example/editor/models/task.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/utils/calculations.dart';

class AddLayerTask extends Task {
  final String regionId;
  final Layer layer;
  AddLayerTask({
    required this.regionId,
    required this.layer,
  }) : super(
            id: generateV4(),
            actionType: ActionType.empty,
            taskType: TaskType.addLayer);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['layer'] = layer.toJson();
    data['regionId'] = regionId;
    return data;
  }

  factory AddLayerTask.fromJson(Map<String, dynamic> json) {
    return AddLayerTask(
      layer: Layer.fromJson(json: json['layer']),
      regionId: json['regionId'],
    );
  }
}
