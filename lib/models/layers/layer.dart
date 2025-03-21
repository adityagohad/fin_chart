import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/region/region_prop.dart';
import 'package:flutter/material.dart';

abstract class Layer with RegionProp {
  final String id;
  final LayerType type;
  bool isLocked = false;
  bool isSelected = false;

  Layer.fromTool({required this.id, required this.type});

  Layer.fromJson({required this.id, required this.type});

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  void drawLayer({required Canvas canvas});

  void drawRightAxisValues({required Canvas canvas}) {}

  void drawLeftAxisValues({required Canvas canvas}) {}

  Layer? onTapDown({required TapDownDetails details}) {
    return null;
  }

  void onScaleUpdate({required ScaleUpdateDetails details}) {}

  void onScaleStart({required ScaleStartDetails details}) {}

  void onUpdateData({required List<ICandle> data}) {}

  void onAimationUpdate(
      {required Canvas canvas, required double animationValue}) {}

  void showSettingsDialog(BuildContext context, Function(Layer) onUpdate) {}

  Widget layerToolTip(
      {Widget? child,
      required Function()? onSettings,
      required Function()? onLockUpdate,
      required Function()? onDelete}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.drag_indicator,
            color: Colors.grey,
          ),
          child ??
              const SizedBox(
                width: 0,
                height: 0,
              ),
          IconButton(onPressed: onSettings, icon: const Icon(Icons.settings)),
          IconButton(
              onPressed: onLockUpdate,
              icon: isLocked
                  ? const Icon(Icons.lock_outline_rounded)
                  : const Icon(Icons.lock_open_rounded)),
          IconButton(
              onPressed: onDelete, icon: const Icon(Icons.delete_rounded))
        ],
      ),
    );
  }
}
