enum StepType { addData, addRegion, addLayer }

enum ActionType { empty, interupt }

abstract class Step {
  final String id;
  final ActionType actionType;
  final StepType stepType;
  Step({required this.id, required this.actionType, required this.stepType});
}



/*

add data
{
  data : [candles],
  stepType : updateData,
}

add region
{
  data : {PlotRegion},
  stepType : addRegion
}

add layer
{
  data : {Layer},
  region : regionId,
  stepType : addLayer
}




*/