import 'package:fin_chart/models/enums/data_fit_type.dart';
import 'package:fin_chart/models/settings/x_axis_settings.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';

class ChartSettings {
  final DataFit dataFit;
  final YAxisSettings yAxisSettings;
  final XAxisSettings xAxisSettings;
  final String mainPlotRegionId;

  ChartSettings(
      {required this.dataFit,
      required this.yAxisSettings,
      required this.xAxisSettings,
      required this.mainPlotRegionId});

  Map<String, dynamic> toJson() {
    return {
      'dataFit': dataFit.name,
      'yAxisSettings': yAxisSettings.toJson(),
      'xAxisSettings': xAxisSettings.toJson(),
      'mainPlotRegionId': mainPlotRegionId,
    };
  }

  factory ChartSettings.fromJson(Map<String, dynamic> json) {
    return ChartSettings(
      dataFit: (json['dataFit'] as String).toDataFit(),
      yAxisSettings: YAxisSettings.fromJson(json['yAxisSettings']),
      xAxisSettings: XAxisSettings.fromJson(json['xAxisSettings']),
      mainPlotRegionId: json['mainPlotRegionId'],
    );
  }
}
