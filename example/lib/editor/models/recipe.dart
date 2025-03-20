import 'package:example/editor/models/task.dart';
import 'package:fin_chart/models/i_candle.dart';

class Recipe {
  late List<ICandle> data;
  late List<Task> tasks;

  Recipe({required this.data, required this.tasks});

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((candle) => candle.toJson()).toList(),
      'tasks': tasks.map((task) => task.toJson()).toList()
    };
  }

  Recipe.fromJson(Map<String, dynamic> json) {
    data = (json['data'] as List)
        .map((candle) => ICandle.fromJson(candle))
        .toList();
    tasks = (json['tasks'] as List).map((task) => Task.fromJson(task)).toList();
  }
}
