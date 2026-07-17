import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:fin_chart/models/sahi_tools_model.dart';
import 'package:fin_chart/models/tasks/toggle_tool_visibility.task.dart';
import 'package:flutter/material.dart';

Future<ToggleToolVisibilityTask?> showToggleToolVisibilityDialog({
  required BuildContext context,
  ToggleToolVisibilityTask? initialTask,
  List<SahiToolsModel> currentTools = const [],
}) async {
  return showDialog<ToggleToolVisibilityTask>(
    context: context,
    builder: (BuildContext context) {
      return _ToggleToolVisibilityDialogContent(
        initialTask: initialTask,
        currentTools: currentTools,
      );
    },
  );
}

class _ToggleToolVisibilityDialogContent extends StatefulWidget {
  final ToggleToolVisibilityTask? initialTask;
  final List<SahiToolsModel> currentTools;

  const _ToggleToolVisibilityDialogContent({
    this.initialTask,
    this.currentTools = const [],
  });

  @override
  State<_ToggleToolVisibilityDialogContent> createState() =>
      _ToggleToolVisibilityDialogContentState();
}

class _ToggleToolVisibilityDialogContentState
    extends State<_ToggleToolVisibilityDialogContent> {
  late List<String> _toolNames;
  late Map<String, bool> _visibility;

  @override
  void initState() {
    super.initState();
    _toolNames = [];
    for (final indicator in IndicatorType.values) {
      _toolNames.add(indicator.name);
    }
    for (final layer in LayerType.values) {
      _toolNames.add(layer.name);
    }

    if (widget.initialTask != null) {
      _visibility = Map<String, bool>.from(widget.initialTask!.visibility);
    } else {
      _visibility = {};
      for (final tool in widget.currentTools) {
        if (tool.isVisible) {
          _visibility[tool.title] = true;
        }
      }
    }
  }

  void _toggle(String name) {
    setState(() {
      _visibility[name] = !(_visibility[name] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialTask != null
          ? 'Edit Tool Visibility'
          : 'Toggle Tool Visibility'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Toggle which tools are shown on the chart.',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _toolNames.map((name) {
                final selected = _visibility[name] ?? false;
                return FilterChip(
                  label: Text(
                    name,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  selected: selected,
                  selectedColor: Colors.blue,
                  backgroundColor: Colors.grey[200],
                  checkmarkColor: Colors.white,
                  onSelected: (_) => _toggle(name),
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
              ToggleToolVisibilityTask(visibility: Map.from(_visibility)),
            );
          },
          child: Text(widget.initialTask != null ? 'Update' : 'Create'),
        ),
      ],
    );
  }
}
