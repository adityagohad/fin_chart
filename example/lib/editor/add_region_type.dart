import 'package:example/editor/step.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/utils/calculations.dart';

class AddRegionStep extends Step {
  final PlotRegion region;
  AddRegionStep({required this.region})
      : super(
            id: generateV4(),
            actionType: ActionType.empty,
            stepType: StepType.addRegion);
}
