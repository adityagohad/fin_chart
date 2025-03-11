import 'package:example/dialog/add_data_dialog.dart';
import 'package:fin_chart/chart.dart';
import 'package:fin_chart/models/layers/horizontal_line.dart';
import 'package:fin_chart/models/layers/trend_line.dart';
import 'package:fin_chart/models/region/dummy_plot_region.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/models/region/rsi_plot_region.dart';
import 'package:fin_chart/models/settings/x_axis_settings.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';
import 'package:flutter/material.dart';
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/ui/region_dialog.dart';
import 'package:fin_chart/models/layers/candle_data.dart';
import 'package:fin_chart/models/layers/rsi_line_data.dart';
import 'package:fin_chart/models/layers/macd_data.dart';
import 'package:fin_chart/models/layers/stochastic_oscillator.dart';

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
<<<<<<< HEAD
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return RegionDialog(
                                onSubmit: (type, variety, yMin, yMax) {
                                  PlotRegion newRegion = PlotRegion(
                                    type: type,
                                    yAxisSettings: const YAxisSettings(
                                        yAxisPos: YAxisPos.right),
                                    yMinValue: yMin,
                                    yMaxValue: yMax,
                                  );

                                  // Add layers based on variety
                                  if (type == PlotRegionType.data) {
                                    if (variety == 'Candle') {
                                      newRegion.layers
                                          .add(CandleData(candles: []));
                                    } else if (variety == 'Line') {
                                      newRegion.layers
                                          .add(LineData(candles: []));
                                    }
                                  } else if (type == PlotRegionType.indicator) {
                                    if (variety == 'RSI') {
                                      newRegion.layers.add(RSILineData(candles: candleData));
                                    } else if (variety == 'MACD') {
                                      newRegion.layers.add(MACDData(candles: candleData));
                                    } else if (variety == 'Stochastic') {
                                      newRegion.layers.add(StochasticOscillator(candles: candleData));
                                    } else {
                                      // Default indicator layer
                                      newRegion.layers
                                          .add(LineData(candles: []));
                                      newRegion.layers
                                          .add(HorizontalLine(value: 3500));
                                    }
                                  }

                                  _chartKey.currentState?.addRegion(newRegion);
                                },
                              );
                            },
                          );
=======
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
>>>>>>> a68eda5a8f7393811a0ff56d3173110f0d54cd3b
                        },
                        child: const Text("Add Region")),
                    ElevatedButton(
                        onPressed: () {
                          _chartKey.currentState?.addLayer(TrendLine(
                              from: const Offset(0, 3700),
                              to: const Offset(4, 3700)));

                          _chartKey.currentState
                              ?.addLayer(HorizontalLine(value: 3400));

                          // _chartKey.currentState
                          //     ?.addLayer(LineData(candles: []));

                          // _chartKey.currentState
                          //     ?.addLayer(SmoothLineData(candles: []));

                          // _chartKey.currentState?.addLayer(RrBox(
                          //     target: 4200,
                          //     stoploss: 3600,
                          //     startPrice: 3800,
                          //     startPointTime: 2,
                          //     endPointTime: 6));
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
