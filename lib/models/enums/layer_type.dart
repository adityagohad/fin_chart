enum LayerType {
  //chartPointer,
  circularArea,
  label,
  horizontalLine,
  horizontalBand,
  trendLine,
  rectArea,
  arrow,
  verticalLine
}

extension LayerTypeExtension on LayerType {
  String get name {
    return toString().split('.').last;
    // switch (this) {
    //   // case LayerType.chartPointer:
    //   //   return 'chartPointer';
    //   case LayerType.circularArea:
    //     return 'circularArea';
    //   case LayerType.label:
    //     return 'label';
    //   case LayerType.trendLine:
    //     return 'trendLine';
    //   case LayerType.horizontalLine:
    //     return 'horizontalLine';
    //   case LayerType.horizontalBand:
    //     return 'horizontalBand';
    //   case LayerType.rectArea:
    //     return 'rectArea';
    //   case LayerType.arrow:
    //     return 'arrow';
    //   case LayerType.verticalLine:
    //     return 'verticalLine';
    // }
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
