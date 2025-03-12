import 'package:example/dialog/add_data_dialog.dart';
import 'package:example/widget/layer_type_dropdown.dart';
import 'package:fin_chart/chart.dart';
import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/region/dummy_plot_region.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/models/region/rsi_plot_region.dart';
import 'package:fin_chart/models/settings/x_axis_settings.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';
import 'package:flutter/material.dart';
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/ui/region_dialog.dart';
import 'package:fin_chart/models/region/macd_plot_region.dart';
import 'package:fin_chart/models/region/stochastic_plot_region.dart';
import 'package:fin_chart/models/enums/plot_region_type.dart';
import 'package:fin_chart/models/region/main_plot_region.dart';

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
  LayerType _selectedType = LayerType.text;
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
          Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text("hey my instruction goes here"),
                ),
              )),
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
                    LayerTypeDropdown(
                        selectedType: _selectedType,
                        onChanged: (layerType) {
                          setState(() {
                            _selectedType = layerType;
                            _chartKey.currentState?.addLayer(layerType);
                          });
                        })
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
        });
  }
}
