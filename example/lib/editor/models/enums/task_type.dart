enum TaskType {
  addData,
  addRegion,
  addLayer,
  addPrompt,
  addLayerOfType,
  waitTask
}

extension TaskTypeExtension on TaskType {
  String get name {
    return toString().split('.').last;
    // switch (this) {
    //   case TaskType.addData:
    //     return "addData";
    //   case TaskType.addRegion:
    //     return "addRegion";
    //   case TaskType.addLayer:
    //     return "addLayer";
    //   case TaskType.addPrompt:
    //     return "addPrompt";
    //   case TaskType.addLayerOfType:
    //     return "addLayerOfType";
    //   case TaskType.waitTask:
    //     return "waitTask";
    // }
  }
}
