import 'package:example/editor/models/enums/action_type.dart';
import 'package:example/editor/models/enums/task_type.dart';
import 'package:example/editor/models/task.dart';
import 'package:fin_chart/models/layers/arrow.dart';
import 'package:fin_chart/models/layers/circular_area.dart';
import 'package:fin_chart/models/layers/horizontal_band.dart';
import 'package:fin_chart/models/layers/horizontal_line.dart';
import 'package:fin_chart/models/layers/label.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/models/layers/rect_area.dart';
import 'package:fin_chart/models/layers/trend_line.dart';
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

  static Layer layerFromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'trendLine':
        return TrendLine.fromJson(json: json);
      case 'horizontalLine':
        return HorizontalLine.fromJson(json: json);
      case 'horizontalBand':
        return HorizontalBand.fromJson(json: json);
      case 'label':
        return Label.fromJson(json: json);
      case 'circularArea':
        return CircularArea.fromJson(json: json);
      case 'rectArea':
        return RectArea.fromJson(json: json);
      case 'arrow':
        return Arrow.fromJson(json: json);
    }
    throw ArgumentError('Invalid layer type: ${json['type']}');
  }
}
