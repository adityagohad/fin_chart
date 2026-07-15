import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:fin_chart/utils/theme.dart';
import 'package:example/editor/ui/pages/sahi_widgets/sahi_icon_helpers.dart';
import 'package:flutter/material.dart';

class SahiToolsPanel extends StatelessWidget {
  final Map<String, bool> enabledTools;
  final VoidCallback onClose;

  const SahiToolsPanel({
    super.key,
    required this.enabledTools,
    required this.onClose,
  });

  bool _isEnabled(String name) => enabledTools[name] ?? true;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final indicators = IndicatorType.values;
    final layers = LayerType.values;

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: colors.sahiDivider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colors.sahiPanelHeaderBg,
              border: Border(bottom: BorderSide(color: colors.sahiDivider)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tools',
                  style: TextStyle(
                    color: colors.sahiTextPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: onClose,
                  child: Icon(Icons.close,
                      color: colors.sahiTextSecondary, size: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 4),
              children: [
                _buildSectionHeader('Indicators', colors),
                ...indicators.map((indicator) {
                  return _buildToolItem(
                    getIndicatorIcon(indicator),
                    indicator.name,
                    enabled: _isEnabled(indicator.name),
                    colors: colors,
                  );
                }),
                const SizedBox(height: 8),
                _buildSectionHeader('Drawing Tools', colors),
                ...layers.map((layer) {
                  return _buildToolItem(
                    getLayerIcon(layer),
                    layer.name,
                    enabled: _isEnabled(layer.name),
                    colors: colors,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, CustomColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          color: colors.sahiTextSecondary,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildToolItem(IconData icon, String label,
      {bool enabled = true, required CustomColors colors}) {
    return InkWell(
      onTap: enabled ? () {} : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.35,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon,
                  color: enabled
                      ? colors.sahiTextPrimary
                      : colors.sahiChipDisabledText,
                  size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: enabled
                        ? colors.sahiTextPrimary
                        : colors.sahiChipDisabledText,
                    fontSize: 13,
                  ),
                ),
              ),
              if (!enabled)
                Icon(Icons.lock_outline,
                    color: colors.sahiChipDisabledText, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
