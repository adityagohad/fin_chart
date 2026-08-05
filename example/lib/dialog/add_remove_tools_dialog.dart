import 'package:fin_chart/models/layers/arrow.dart';
import 'package:fin_chart/models/layers/arrow_text_pointer.dart';
import 'package:fin_chart/models/layers/circular_area.dart';
import 'package:fin_chart/models/layers/horizontal_band.dart';
import 'package:fin_chart/models/layers/horizontal_line.dart';
import 'package:fin_chart/models/layers/label.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/models/layers/parallel_channel.dart';
import 'package:fin_chart/models/layers/rect_area.dart';
import 'package:fin_chart/models/layers/trend_line.dart';
import 'package:fin_chart/models/indicators/adx.dart';
import 'package:fin_chart/models/indicators/atr.dart';
import 'package:fin_chart/models/indicators/bollinger_bands.dart';
import 'package:fin_chart/models/indicators/ema.dart';
import 'package:fin_chart/models/indicators/ev_ebitda.dart';
import 'package:fin_chart/models/indicators/ev_sales.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:fin_chart/models/indicators/macd.dart';
import 'package:fin_chart/models/indicators/mfi.dart';
import 'package:fin_chart/models/indicators/pb.dart';
import 'package:fin_chart/models/indicators/pe.dart';
import 'package:fin_chart/models/indicators/pivot_point.dart';
import 'package:fin_chart/models/indicators/roc.dart';
import 'package:fin_chart/models/indicators/rsi.dart';
import 'package:fin_chart/models/indicators/scanner_indicator.dart';
import 'package:fin_chart/models/indicators/sma.dart';
import 'package:fin_chart/models/indicators/stochastic.dart';
import 'package:fin_chart/models/indicators/supertrend.dart';
import 'package:fin_chart/models/indicators/vwap.dart';
import 'package:fin_chart/models/sahi_tools_model.dart';
import 'package:fin_chart/models/tasks/add_remove_tools.task.dart';
import 'package:flutter/material.dart';

Future<AddRemoveToolsTask?> showAddRemoveToolsDialog({
  required BuildContext context,
  AddRemoveToolsTask? initialTask,
  List<SahiToolsModel> currentTools = const [],
}) async {
  return showDialog<AddRemoveToolsTask>(
    context: context,
    builder: (BuildContext context) {
      return _AddRemoveToolsDialogContent(
        initialTask: initialTask,
        currentTools: currentTools,
      );
    },
  );
}

class _AddRemoveToolsDialogContent extends StatefulWidget {
  final AddRemoveToolsTask? initialTask;
  final List<SahiToolsModel> currentTools;

  const _AddRemoveToolsDialogContent({
    this.initialTask,
    this.currentTools = const [],
  });

  @override
  State<_AddRemoveToolsDialogContent> createState() =>
      _AddRemoveToolsDialogContentState();
}

class _AddRemoveToolsDialogContentState
    extends State<_AddRemoveToolsDialogContent> {
  late List<String> _toolNames;
  late Map<String, bool> _enabled;
  late Map<String, Map<String, dynamic>> _toolConfigs;

  @override
  void initState() {
    super.initState();
    _toolNames = widget.currentTools.map((t) => t.title).toList();

    if (widget.initialTask != null) {
      _enabled = Map<String, bool>.from(widget.initialTask!.enabled);
      _toolConfigs =
          Map<String, Map<String, dynamic>>.from(widget.initialTask!.toolConfigs);
    } else {
      _enabled = {};
      _toolConfigs = {};
      for (final tool in widget.currentTools) {
        if (tool.isEnabled) {
          _enabled[tool.title] = true;
        }
      }
    }
  }

  void _toggle(String name) {
    setState(() {
      _enabled[name] = !(_enabled[name] ?? false);
    });
  }

  bool _hasSettings(String name) {
    final isIndicator = IndicatorType.values.any((t) => t.name == name);
    if (isIndicator) return true;
    return name != 'verticalLine';
  }

  void _openToolSettings(String name) {
    final existing = _toolConfigs[name];

    final indicatorType = IndicatorType.values
        .where((t) => t.name == name)
        .firstOrNull;
    if (indicatorType != null) {
      final indicator = existing != null
          ? Indicator.fromJson(json: existing)
          : _defaultIndicator(indicatorType);
      indicator.showIndicatorSettings(
        context: context,
        onUpdate: (updated) {
          if (mounted) {
            setState(() {
              _toolConfigs[name] = updated.toJson();
            });
          }
        },
      );
      return;
    }

    final layer = existing != null
        ? Layer.fromJson(json: existing)
        : _defaultLayer(name);
    if (layer == null) return;
    layer.showSettingsDialog(context, (updated) {
      if (mounted) {
        setState(() {
          _toolConfigs[name] = updated.toJson();
        });
      }
    });
  }

  Indicator _defaultIndicator(IndicatorType type) {
    switch (type) {
      case IndicatorType.rsi:
        return Rsi();
      case IndicatorType.macd:
        return Macd();
      case IndicatorType.sma:
        return Sma();
      case IndicatorType.ema:
        return Ema();
      case IndicatorType.bollingerBand:
        return BollingerBands();
      case IndicatorType.stochastic:
        return Stochastic();
      case IndicatorType.atr:
        return Atr();
      case IndicatorType.mfi:
        return Mfi();
      case IndicatorType.adx:
        return Adx();
      case IndicatorType.pivotPoint:
        return PivotPoint();
      case IndicatorType.pe:
        return Pe();
      case IndicatorType.pb:
        return Pb();
      case IndicatorType.supertrend:
        return Supertrend();
      case IndicatorType.vwap:
        return Vwap();
      case IndicatorType.evEbitda:
        return EvEbitda();
      case IndicatorType.evSales:
        return EvSales();
      case IndicatorType.scanner:
        return ScannerIndicator();
      case IndicatorType.roc:
        return Roc();
    }
  }

  Layer? _defaultLayer(String name) {
    switch (name) {
      case 'horizontalLine':
        return HorizontalLine.fromTool(value: 0);
      case 'trendLine':
        return TrendLine.fromTool(
            from: Offset.zero, to: Offset.zero, startPoint: Offset.zero);
      case 'label':
        return Label.fromTool(
            pos: Offset.zero,
            label: 'Text',
            textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold));
      case 'horizontalBand':
        return HorizontalBand.fromTool(value: 0, allowedError: 70);
      case 'rectArea':
        return RectArea.fromTool(
            topLeft: Offset.zero,
            bottomRight: Offset.zero,
            dragStartPos: Offset.zero);
      case 'circularArea':
        return CircularArea.fromTool(point: Offset.zero);
      case 'arrow':
        return Arrow.fromTool(
            from: Offset.zero, to: Offset.zero, startPoint: Offset.zero);
      case 'parallelChannel':
        return ParallelChannel.fromTool(
            topLeft: Offset.zero,
            bottomRight: Offset.zero,
            dragPoint: Offset.zero);
      case 'arrowTextPointer':
        return ArrowTextPointer.fromTool(pos: Offset.zero, label: "");
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.initialTask != null ? 'Edit Add/Remove Tools' : 'Add/Remove Tools'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Toggle which tools are interactive.',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _toolNames.map((name) {
                final selected = _enabled[name] ?? false;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FilterChip(
                      label: Text(
                        name,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      selected: selected,
                      selectedColor: Colors.green,
                      backgroundColor: Colors.grey[200],
                      checkmarkColor: Colors.white,
                      onSelected: (_) => _toggle(name),
                    ),
                    if (_hasSettings(name))
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 32, minHeight: 32),
                        iconSize: 18,
                        tooltip: 'Configure $name',
                        icon: Icon(Icons.settings,
                            color: _toolConfigs.containsKey(name)
                                ? Colors.green
                                : Colors.grey[600]),
                        onPressed: () => _openToolSettings(name),
                      ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(
              AddRemoveToolsTask(
                enabled: Map.from(_enabled),
                toolConfigs: Map.from(_toolConfigs),
              ),
            );
          },
          child: Text(widget.initialTask != null ? 'Update' : 'Create'),
        ),
      ],
    );
  }
}
