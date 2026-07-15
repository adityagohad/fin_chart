import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:fin_chart/models/sahi_tools_model.dart';
import 'package:fin_chart/models/tasks/show_tools.task.dart';
import 'package:flutter/material.dart';

Future<ShowToolsTask?> showShowToolsDialog({
  required BuildContext context,
  ShowToolsTask? initialTask,
}) async {
  return showDialog<ShowToolsTask>(
    context: context,
    builder: (BuildContext context) {
      return _ShowToolsDialogContent(initialTask: initialTask);
    },
  );
}

class _ShowToolsDialogContent extends StatefulWidget {
  final ShowToolsTask? initialTask;

  const _ShowToolsDialogContent({this.initialTask});

  @override
  State<_ShowToolsDialogContent> createState() =>
      _ShowToolsDialogContentState();
}

class _ShowToolsDialogContentState extends State<_ShowToolsDialogContent> {
  late List<SahiToolsModel> _tools;

  @override
  void initState() {
    super.initState();
    if (widget.initialTask != null) {
      _tools = widget.initialTask!.tools
          .map((t) => SahiToolsModel(
                title: t.title,
                isVisible: t.isVisible,
                isEnabled: t.isEnabled,
              ))
          .toList();
    } else {
      _tools = [];
      for (final indicator in IndicatorType.values) {
        _tools.add(SahiToolsModel(title: indicator.name));
      }
      for (final layer in LayerType.values) {
        _tools.add(SahiToolsModel(title: layer.name));
      }
    }
  }

  SahiToolsModel _getTool(String name) {
    return _tools.firstWhere((t) => t.title == name);
  }

  void _toggleVisible(String name) {
    setState(() {
      final tool = _getTool(name);
      tool.isVisible = !tool.isVisible;
      if (!tool.isVisible) {
        tool.isEnabled = false;
      }
    });
  }

  void _toggleEnabled(String name) {
    setState(() {
      final tool = _getTool(name);
      if (!tool.isVisible) return;
      tool.isEnabled = !tool.isEnabled;
    });
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required List<SahiToolsModel> tools,
    required bool Function(SahiToolsModel) isSelected,
    required void Function(String) onToggle,
    required Color selectedColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tools.map((tool) {
            final selected = isSelected(tool);
            return FilterChip(
              label: Text(
                tool.title,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              selected: selected,
              selectedColor: selectedColor,
              backgroundColor: Colors.grey[200],
              checkmarkColor: Colors.white,
              onSelected: (_) => onToggle(tool.title),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleTools = _tools.where((t) => t.isVisible).toList();

    return AlertDialog(
      title:
          Text(widget.initialTask != null ? 'Edit Show Tools' : 'Show Tools'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Visible Tools',
              subtitle: 'Toggle which tools are shown on the chart.',
              tools: _tools,
              isSelected: (t) => t.isVisible,
              onToggle: _toggleVisible,
              selectedColor: Colors.blue,
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: 'Enabled Tools',
              subtitle: 'Toggle which visible tools are interactive.',
              tools: visibleTools,
              isSelected: (t) => t.isEnabled,
              onToggle: _toggleEnabled,
              selectedColor: Colors.green,
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
              ShowToolsTask(
                tools: _tools
                    .map((t) => SahiToolsModel(
                          title: t.title,
                          isVisible: t.isVisible,
                          isEnabled: t.isEnabled,
                        ))
                    .toList(),
              ),
            );
          },
          child: Text(widget.initialTask != null ? 'Update' : 'Create'),
        ),
      ],
    );
  }
}
