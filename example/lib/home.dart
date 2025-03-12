import 'package:example/dialog/add_data_dialog.dart';
import 'package:fin_chart/chart.dart';
import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/models/region/rsi_plot_region.dart';
import 'package:fin_chart/models/settings/x_axis_settings.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';
import 'package:flutter/material.dart';
import 'package:fin_chart/models/i_candle.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ChartState> _chartKey = GlobalKey();
  List<ICandle> candleData = [];
  List<PlotRegion> regions = [
    // PlotRegion(
    //     type: PlotRegionType.indicator,
    //     yAxisSettings: const YAxisSettings(yAxisPos: YAxisPos.right),
    //     yMinValue: -100,
    //     yMaxValue: 100,
    //     layers: [
    //       LineData(candles: []),
    //       HorizontalLine(value: 3500),
    //     ])
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Finance Charts"),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Flexible(flex: 1, child: Container()),
          Flexible(
            flex: 9,
            child: Chart(
              key: _chartKey,
              yAxisSettings: const YAxisSettings(yAxisPos: YAxisPos.right),
              xAxisSettings: const XAxisSettings(xAxisPos: XAxisPos.bottom),
              candles: candleData,
              regions: regions,
            ),
          ),
          Flexible(
              flex: 1,
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // ElevatedButton(
                    //     onPressed: _showAddDataDialog,
                    //     child: const Text("Action")),
                    ElevatedButton(
                        onPressed: _showAddDataDialog,
                        child: const Text("Add Data")),
                    ElevatedButton(
                        onPressed: () {
                          // _chartKey.currentState?.addRegion(DummyPlotRegion(
                          //   candles: [],
                          //   yAxisSettings:
                          //       const YAxisSettings(yAxisPos: YAxisPos.right),

                          //   // yMinValue: -100,
                          //   // yMaxValue: 100,
                          //   // layers: [
                          //   //   HorizontalLine(value: 37),
                          //   // ],
                          // ));

                          _chartKey.currentState?.addRegion(RsiPlotRegion(
                            candles: [],
                            yAxisSettings:
                                const YAxisSettings(yAxisPos: YAxisPos.right),

                            // yMinValue: -100,
                            // yMaxValue: 100,
                            // layers: [
                            //   HorizontalLine(value: 37),
                            // ],
                          ));
                        },
                        child: const Text("Add Region")),
                    ElevatedButton(
                        onPressed: () {
                          _chartKey.currentState
                              ?.addLayer(LayerType.horizontalLine);
                          // _chartKey.currentState?.addLayerDeprecated(TrendLine(
                          //     from: const Offset(0, 3700),
                          //     to: const Offset(4, 3700)));

                          // _chartKey.currentState
                          //     ?.addLayerDeprecated(HorizontalLine(value: 3400));

                          // // _chartKey.currentState
                          // //     ?.addLayer(LineData(candles: []));

                          // // _chartKey.currentState
                          // //     ?.addLayer(SmoothLineData(candles: []));

                          // // _chartKey.currentState?.addLayer(RrBox(
                          // //     target: 4200,
                          // //     stoploss: 3600,
                          // //     startPrice: 3800,
                          // //     startPointTime: 2,
                          // //     endPointTime: 6));
                        },
                        child: const Text("Add Layer")),
                  ],
                ),
              ))
        ],
      )),
    );
  }

  void _showAddDataDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddDataDialog(onDataUpdate: (data) {
            _chartKey.currentState?.addData(data);
          });
        });
  }
}
