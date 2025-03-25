enum DataFit { fixedWidth, adaptiveWidth }

extension DataFitParsingExtension on String {
  DataFit toDataFit({bool ignoreCase = true}) {
    final input = ignoreCase ? toLowerCase() : this;

    for (final fit in DataFit.values) {
      final fitName = fit.toString().split('.').last;
      final compareValue = ignoreCase ? fitName.toLowerCase() : fitName;

      if (input == compareValue) {
        return fit;
      }
    }

    return DataFit.adaptiveWidth;
  }
}
