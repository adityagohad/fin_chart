import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:fin_chart/models/tasks/open_tool_panel.task.dart';
import 'package:flutter/material.dart';

Future<OpenToolPanelTask?> showOpenToolsPanelDialog({
  required BuildContext context,
  OpenToolPanelTask? initialTask,
}) async {
  return showDialog<OpenToolPanelTask>(
    context: context,
    builder: (BuildContext context) {
      return _OpenToolsPanelDialogContent(initialTask: initialTask);
    },
  );
}

class _OpenToolsPanelDialogContent extends StatefulWidget {
  final OpenToolPanelTask? initialTask;

  const _OpenToolsPanelDialogContent({this.initialTask});

  @override
  State<_OpenToolsPanelDialogContent> createState() =>
      _OpenToolsPanelDialogContentState();
}

class _OpenToolsPanelDialogContentState
    extends State<_OpenToolsPanelDialogContent> {
  late Map<String, bool> _enabledTools;

  @override
  void initState() {
    super.initState();
    if (widget.initialTask != null) {
      _enabledTools = Map<String, bool>.from(widget.initialTask!.enabledTools);
    } else {
      _enabledTools = {};
    }
  }

  bool _isEnabled(String toolName) {
    return _enabledTools[toolName] ?? true;
  }

  void _toggleTool(String toolName) {
    setState(() {
      _enabledTools[toolName] = !_isEnabled(toolName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final indicators = IndicatorType.values;
    final layers = LayerType.values;

    return AlertDialog(
      title: Text(
          widget.initialTask != null ? 'Edit Tool Panel' : 'Open Tool Panel'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Indicators',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Toggle which indicators are available on the chart.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: indicators.map((indicator) {
                final enabled = _isEnabled(indicator.name);
                return FilterChip(
                  label: Text(
                    indicator.name,
                    style: TextStyle(
                      color: enabled ? Colors.white : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  selected: enabled,
                  selectedColor: Colors.blue,
                  backgroundColor: Colors.grey[200],
                  checkmarkColor: Colors.white,
                  onSelected: (_) => _toggleTool(indicator.name),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Drawing Tools',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Toggle which drawing tools are available on the chart.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: layers.map((layer) {
                final enabled = _isEnabled(layer.name);
                return FilterChip(
                  label: Text(
                    layer.name,
                    style: TextStyle(
                      color: enabled ? Colors.white : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  selected: enabled,
                  selectedColor: Colors.blue,
                  backgroundColor: Colors.grey[200],
                  checkmarkColor: Colors.white,
                  onSelected: (_) => _toggleTool(layer.name),
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
              OpenToolPanelTask(
                open: true,
                enabledTools: Map<String, bool>.from(_enabledTools),
              ),
            );
          },
          child: Text(widget.initialTask != null ? 'Update' : 'Create'),
        ),
      ],
    );
  }
}
