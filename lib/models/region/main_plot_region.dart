import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/utils/calculations.dart';

// class MainPlotRegion extends PlotRegion {
//   MainPlotRegion(super.baseLayer,
//       {required super.type, required super.yAxisSettings});

//   @override
//   void updateData(List<ICandle> data) {
//     (double, double) range = findMinMaxWithPercentage(data);
//     yMinValue = range.$1;
//     yMaxValue = range.$2;

//     List<double> yValues = generateNiceAxisValues(yMinValue, yMaxValue);

//     yMinValue = yValues.first;
//     yMaxValue = yValues.last;

//     yLabelSize = getLargetRnderBoxSizeForList(
//         yValues.map((v) => v.toString()).toList(), yAxisSettings.axisTextStyle);

//     baseLayer.onUpdateData(data: data);

//     for (final layer in layers) {
//       layer.onUpdateData(data: data);
//     }
//   }
// }
