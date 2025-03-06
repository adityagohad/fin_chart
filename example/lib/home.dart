import 'package:example/dialog/add_data_dialog.dart';
import 'package:fin_chart/chart.dart';
import 'package:fin_chart/models/layers/horizontal_line.dart';
import 'package:fin_chart/models/layers/line_data.dart';
import 'package:fin_chart/models/layers/trend_line.dart';
import 'package:fin_chart/models/region/plot_region.dart';
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
  List<PlotRegion> regions = [];
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
          ),
          Flexible(
              flex: 1,
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: _showAddDataDialog,
                        child: const Text("Add Data")),
                    ElevatedButton(
                        onPressed: () {
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
                        },
                        child: const Text("Add Region")),
                    ElevatedButton(
                        onPressed: () {
                          _chartKey.currentState?.addLayer(TrendLine(
                              from: const Offset(0, 3700),
                              to: const Offset(4, 3700)));
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
