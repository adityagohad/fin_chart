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

  @override
  void initState() {
    super.initState();
    _toolNames = widget.currentTools.map((t) => t.title).toList();

    if (widget.initialTask != null) {
      _enabled = Map<String, bool>.from(widget.initialTask!.enabled);
    } else {
      _enabled = {};
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
                return FilterChip(
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
              AddRemoveToolsTask(enabled: Map.from(_enabled)),
            );
          },
          child: Text(widget.initialTask != null ? 'Update' : 'Create'),
        ),
      ],
    );
  }
}
