import 'package:fin_chart/models/recipe.dart';
import 'package:fin_chart/models/tasks/add_option_chain.task.dart';
import 'package:fin_chart/models/tasks/choose_correct_option_chain_task.dart';
import 'package:fin_chart/models/tasks/show_insights_page.task.dart';
import 'package:fin_chart/models/tasks/table_task.dart';
import 'package:fin_chart/fin_chart.dart';
import 'package:fin_chart/option_chain/screens/preview_screen.dart';
import 'package:fin_chart/utils/theme.dart';
import 'package:example/editor/ui/pages/sahi_widgets/sahi_tools_panel.dart';
import 'package:example/editor/ui/widget/table_display_widget.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

class SahiContentArea extends StatelessWidget {
  final String promptText;
  final String hintText;
  final bool isToolPanelOpen;
  final Map<String, bool> enabledTools;
  final VoidCallback onToolPanelClose;
  final int currentPageIndex;
  final List<Map<String, String>> tabs;
  final Recipe recipe;
  final Map<String, GlobalKey<ChartState>> chartKeys;
  final GlobalKey<PreviewScreenState> previewScreenKey;
  final Map<String, GlobalKey<PreviewScreenState>> previewScreenKeys;
  final List<AddOptionChainTask> optionChainTasks;
  final List<ShowPayOffGraphTask> payoffGraphTasks;
  final Map<String, List<GlobalKey<TableDisplayWidgetState>>> tableWidgetKeys;
  final Map<String, Map<int, Set<int>>> userSelectedRows;
  final Function(Map<int, Set<int>>) onTableSelectionChanged;
  final Function(Offset, Offset)? onInteraction;

  const SahiContentArea({
    super.key,
    required this.promptText,
    required this.hintText,
    required this.isToolPanelOpen,
    required this.enabledTools,
    required this.onToolPanelClose,
    required this.currentPageIndex,
    required this.tabs,
    required this.recipe,
    required this.chartKeys,
    required this.previewScreenKey,
    required this.previewScreenKeys,
    required this.optionChainTasks,
    required this.payoffGraphTasks,
    required this.tableWidgetKeys,
    required this.userSelectedRows,
    required this.onTableSelectionChanged,
    this.onInteraction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (promptText.isNotEmpty) _buildPromptArea(context),
        Expanded(
          child: Row(
            children: [
              if (isToolPanelOpen)
                SahiToolsPanel(
                  enabledTools: enabledTools,
                  onClose: onToolPanelClose,
                ),
              Expanded(
                child: tabs.isEmpty
                    ? const SizedBox.shrink()
                    : IndexedStack(
                        index: currentPageIndex.clamp(0, tabs.length - 1),
                        children: tabs
                            .map((tab) => _buildTabContent(context, tab))
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPromptArea(BuildContext context) {
    final colors = Theme.of(context).customColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: colors.sahiPromptBg,
      child: Column(
        children: [
          MarkdownWidget(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              data: promptText),
          if (hintText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                hintText,
                style: TextStyle(color: colors.sahiTextSecondary, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, Map<String, String> tab) {
    switch (tab["type"]) {
      case "chart":
        final taskId = tab["taskId"];
        final chartKey = taskId != null ? chartKeys[taskId] : null;
        if (chartKey == null) {
          return const Center(child: Text('Chart not found'));
        }
        return Chart(
            key: chartKey,
            candles: const [],
            onInteraction: onInteraction,
            theme: Theme.of(context));
      case "option_chain":
        return _buildOptionChainTab(tab);
      case "payoff":
        return _buildPayoffTab(tab);
      case "insights":
        return _buildInsightsTab(tab);
      case "table":
        return _buildTableTab(context, tab);
      case "insights_v2":
        return _buildInsightsV2Tab(tab);
      default:
        return Container();
    }
  }

  Widget _buildOptionChainTab(Map<String, String> tab) {
    final taskId = tab["taskId"]!;
    final chooseTask = recipe.tasks
        .whereType<ChooseCorrectOptionValueChainTask>()
        .firstWhere((t) => t.taskId == taskId);
    final optionChainTask = optionChainTasks.firstWhere(
      (t) => t.optionChainId == chooseTask.taskId,
      orElse: () => optionChainTasks.first,
    );
    return PreviewScreen.from(
        key: previewScreenKeys[taskId] ?? previewScreenKey,
        task: optionChainTask,
        isEditorMode: false,
        maxSelectableRows: chooseTask.maxSelectableRows);
  }

  Widget _buildPayoffTab(Map<String, String> tab) {
    final taskId = tab["taskId"]!;
    final payoffTask = payoffGraphTasks.firstWhere(
      (t) => t.id == taskId,
      orElse: () => payoffGraphTasks.first,
    );
    return Container(
      color: Colors.blue.withValues(alpha: 0.1),
      child: Center(
        child: Text("Payoff Graph View for ${payoffTask.id}"),
      ),
    );
  }

  Widget _buildInsightsTab(Map<String, String> tab) {
    final taskId = tab["taskId"]!;
    final insightsTask = recipe.tasks
        .whereType<ShowInsightsPageTask>()
        .firstWhere((t) => t.id == taskId);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarkdownWidget(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            data: insightsTask.title,
            config: MarkdownConfig(configs: [
              H1Config(
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ]),
          ),
          const SizedBox(height: 16),
          MarkdownWidget(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              data: insightsTask.description),
        ],
      ),
    );
  }

  Widget _buildTableTab(BuildContext context, Map<String, String> tab) {
    final taskId = tab["taskId"]!;
    final tableTask =
        recipe.tasks.whereType<TableTask>().firstWhere((t) => t.id == taskId);
    if (!tableWidgetKeys.containsKey(taskId)) {
      tableWidgetKeys[taskId] = List.generate(
        tableTask.tables.tables.length,
        (_) => GlobalKey<TableDisplayWidgetState>(),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...tableTask.tables.tables.asMap().entries.map((entry) {
            final idx = entry.key;
            final table = entry.value;
            final selectedRows = userSelectedRows[taskId]?[idx] ?? <int>{};
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    table.tableTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (table.tableDescription.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        table.tableDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  TableDisplayWidget(
                    key: tableWidgetKeys[taskId]![idx],
                    columns: table.columns,
                    rows: table.rows,
                    selectedRowIndices: selectedRows,
                    onRowTap: (rowIdx) {
                      final selected =
                          userSelectedRows[taskId]?[idx] ?? <int>{};
                      if (selected.contains(rowIdx)) {
                        selected.remove(rowIdx);
                      } else {
                        selected.add(rowIdx);
                      }
                      onTableSelectionChanged({idx: selected});
                    },
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInsightsV2Tab(Map<String, String> tab) {
    final taskId = tab["taskId"]!;
    final insightsTask = recipe.tasks
        .whereType<ShowInsightsPageV2Task>()
        .firstWhere((t) => t.id == taskId);
    return InsightsPreviewPage(task: insightsTask);
  }
}
