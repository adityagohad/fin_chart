enum CandleState { natural, highlighted, selected }

extension CandleStateExtension on CandleState {
  String get name {
    return toString().split('.').last;
  }
}

extension CandleStateParsingExtension on String {
  CandleState toCandleState({bool ignoreCase = true}) {
    final input = ignoreCase ? toLowerCase() : this;

    for (final type in CandleState.values) {
      final typeName = type.toString().split('.').last;
      final compareValue = ignoreCase ? typeName.toLowerCase() : typeName;

      if (input == compareValue) {
        return type;
      }
    }

    return CandleState.natural;
  }
}
