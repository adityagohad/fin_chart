import 'package:fin_chart/models/settings/axis_settings.dart';

enum XAxisPos { top, bottom }

class XAxisSettings extends AxisSettings {
  final XAxisPos xAxisPos;

  const XAxisSettings(
      {super.axisTextStyle,
      super.axisColor,
      super.strokeWidth,
      this.xAxisPos = XAxisPos.bottom});
}
