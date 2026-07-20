import 'package:fin_chart/models/sahi_tools_model.dart';
import 'package:fin_chart/utils/theme.dart';
import 'package:example/editor/ui/pages/sahi_widgets/sahi_icon_helpers.dart';
import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:flutter/material.dart';

class SahiToolsBar extends StatelessWidget {
  final List<SahiToolsModel> tools;
  final void Function(String toolName)? onToolTap;
  final Widget? trailing;

  const SahiToolsBar(
      {super.key, required this.tools, this.onToolTap, this.trailing});

  IconData _getIcon(String name) {
    for (final indicator in IndicatorType.values) {
      if (indicator.name == name) return getIndicatorIcon(indicator);
    }
    for (final layer in LayerType.values) {
      if (layer.name == name) return getLayerIcon(layer);
    }
    return Icons.build;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final visibleTools = tools.where((t) => t.isVisible).toList();

    if (visibleTools.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: colors.sahiDivider, width: 0.35),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Tools',
                style: TextStyle(
                  color: colors.sahiTextPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colors.sahiChipEnabledBg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: colors.sahiTabBorder, width: 1),
                  ),
                  child: SizedBox(
                    height: 32,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: visibleTools.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 6),
                      itemBuilder: (context, index) {
                        final tool = visibleTools[index];
                        return GestureDetector(
                          onTap: tool.isEnabled
                              ? () => onToolTap?.call(tool.title)
                              : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: tool.isEnabled
                                  ? colors.sahiPanelItemBg
                                  : null,
                              borderRadius: BorderRadius.circular(6),
                              border: tool.isEnabled
                                  ? Border.all(
                                      color: colors.sahiTabBorder,
                                      width: 1,
                                    )
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getIcon(tool.title),
                                  size: 13,
                                  color: tool.isEnabled
                                      ? colors.sahiChipEnabledText
                                      : colors.sahiChipDisabledText,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  tool.title,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: tool.isEnabled
                                        ? colors.sahiChipEnabledText
                                        : colors.sahiChipDisabledText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
