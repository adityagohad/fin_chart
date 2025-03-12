import 'package:example/dialog/add_data_dialog.dart';
import 'package:fin_chart/chart.dart';
import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/models/region/rsi_plot_region.dart';
import 'package:fin_chart/models/settings/x_axis_settings.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';
import 'package:flutter/material.dart';
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/ui/region_dialog.dart';
import 'package:fin_chart/models/region/macd_plot_region.dart';
import 'package:fin_chart/models/region/stochastic_plot_region.dart';
import 'package:fin_chart/models/layers/line_data.dart';
import 'package:fin_chart/models/enums/plot_region_type.dart';
import 'package:fin_chart/models/region/main_plot_region.dart';
import 'package:fin_chart/models/ui/layer_dialog.dart';
import 'package:fin_chart/models/layers/rr_box.dart';
import 'package:fin_chart/models/layers/sma_data.dart';
import 'package:fin_chart/models/layers/ema_data.dart';
import 'package:fin_chart/models/layers/bollinger_bands_data.dart';

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
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return RegionDialog(
                                onSubmit: (type, variety, yMin, yMax) {
                                  if (type == PlotRegionType.indicator) {
                                    if (variety == 'RSI') {
                                      _chartKey.currentState
                                          ?.addRegion(RsiPlotRegion(
                                        type: type,
                                        yAxisSettings: const YAxisSettings(
                                            yAxisPos: YAxisPos.right),
                                        candles: [],
                                      ));
                                    } else if (variety == 'MACD') {
                                      // Add MACD region with custom min/max values
                                      _chartKey.currentState
                                          ?.addRegion(MACDPlotRegion(
                                        candles: [],
                                        type: type,
                                        yAxisSettings: const YAxisSettings(
                                            yAxisPos: YAxisPos.right),
                                      ));
                                    } else if (variety == 'Stochastic') {
                                      // Add Stochastic region with fixed 0-100 bounds
                                      _chartKey.currentState
                                          ?.addRegion(StochasticPlotRegion(
                                        candles: [],
                                        type: type,
                                        yAxisSettings: const YAxisSettings(
                                            yAxisPos: YAxisPos.right),
                                      ));
                                    }
                                  } else if (type == PlotRegionType.data) {
                                    if (variety == 'Candle') {
                                      _chartKey.currentState
                                          ?.addRegion(MainPlotRegion(
                                        candles: [],
                                        type: type,
                                        yAxisSettings: const YAxisSettings(
                                            yAxisPos: YAxisPos.right),
                                      ));
                                    } else if (variety == 'Line') {
                                      // Add line chart region
                                      _chartKey.currentState
                                          ?.addRegion(DummyPlotRegion(
                                        candles: [],
                                        type: type,
                                        yAxisSettings: const YAxisSettings(
                                            yAxisPos: YAxisPos.right),
                                      ));
                                    }
                                  }
                                },
                              );
                            });
                      },
                      child: const Text("Add Region"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return LayerDialog(
                              onSubmit: (type, variety) {
                                if (type == 'Indicator') {
                                  if (variety == 'SMA') {

                                    // Use chartKey directly to add the layer
                                    final sma = SmaData(
                                      candles: List.from(candleData),
                                      lineColor: Colors.purple,
                                    );

                                    _chartKey.currentState?.addLayer(sma);
                                  } else if (variety == 'EMA') {
                                    // Use chartKey directly to add the layer
                                    final ema = EmaData(
                                      candles: List.from(candleData),
                                      lineColor: Colors.orange,
                                    );

                                    _chartKey.currentState?.addLayer(ema);
                                  } else if (variety == 'BollingerBands') {
                                    final bollingerBands = BollingerBandsData(
                                      candles: List.from(candleData),
                                      period: 20,
                                      multiplier: 2.0,
                                      middleBandColor: Colors.blue,
                                      upperBandColor: Colors.red,
                                      lowerBandColor: Colors.green,
                                    );

                                    _chartKey.currentState?.addLayer(bollingerBands);
                                  }
                                } else if (type == 'Drawing') {
                                  if (variety == 'TrendLine') {
                                    _chartKey.currentState?.addLayer(TrendLine(
                                        from: const Offset(0, 3700),
                                        to: const Offset(4, 3700)));
                                  } else if (variety == 'HorizontalLine') {
                                    _chartKey.currentState
                                        ?.addLayer(HorizontalLine(value: 3400));
                                  } else if (variety == 'RrBox') {
                                    _chartKey.currentState?.addLayer(RrBox(
                                        target: 4200,
                                        stoploss: 3600,
                                        startPrice: 3800,
                                        startPointTime: 2,
                                        endPointTime: 6));
                                  }
                                }
                              },
                            );
                          },
                        );
                      },
                      child: const Text("Add Layer"),
                    ),
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
          setState(() {
            // Update the local candleData list
            candleData.addAll(data);
          });
          // Then update the chart
          _chartKey.currentState?.addData(data);
        });
      }
    );
  }
}
