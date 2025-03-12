enum LayerType {
  chartPointer,
  text,
  trendLine,
  horizontalLine,
  horizontalBand,
  rectArea,
}

extension LayerTypeExtension on LayerType {
  String get name {
    switch (this) {
      case LayerType.chartPointer:
        return 'chartPointer';
      case LayerType.text:
        return 'text';
      case LayerType.trendLine:
        return 'trendLine';
      case LayerType.horizontalLine:
        return 'horizontalLine';
      case LayerType.horizontalBand:
        return 'horizontalBand';
      case LayerType.rectArea:
        return 'rectArea';
    }
  }
}

extension LayerTypeParsingExtension on String {
  LayerType? toLayerType({bool ignoreCase = true}) {
    final input = ignoreCase ? toLowerCase() : this;

    for (final type in LayerType.values) {
      final typeName = type.toString().split('.').last;
      final compareValue = ignoreCase ? typeName.toLowerCase() : typeName;

      if (input == compareValue) {
        return type;
      }
    }

    return null;
  }
}
