import 'package:example/editor/step.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/utils/calculations.dart';

class AddLayerStep extends Step {
  final Layer layer;
  final String regionId;
  AddLayerStep({required this.layer, required this.regionId})
      : super(
            id: generateV4(),
            actionType: ActionType.empty,
            stepType: StepType.addRegion);
}
