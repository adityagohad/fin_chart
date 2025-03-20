enum TaskType {
  addData,
  addRegion,
  addLayer,
  addPrompt,
  // addLayerOfType,
  waitTask
}

extension TaskTypeExtension on TaskType {
  String get name {
    return toString().split('.').last;
  }
}
