import 'package:fin_chart/chart.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/models/settings/x_axis_settings.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';
import 'package:flutter/material.dart';
import 'package:fin_chart/candle_stick_generator.dart';
import 'package:fin_chart/models/i_candle.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          Flexible(
            flex: 7,
            child: SizedBox(
              width: double.infinity,
              child: Chart(
                yAxisSettings: const YAxisSettings(yAxisPos: YAxisPos.right),
                xAxisSettings: const XAxisSettings(xAxisPos: XAxisPos.bottom),
                candles: candleData,
                regions: regions,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),

          // Flexible(
          //   flex: 3, // 2 parts out of 5 total parts
          //   child: Container(
          //     color: Colors.red,
          //     width: double.infinity,
          //   ),
          // ),

          // Second section - 3:5 ratio (taking 60% of height)
          Flexible(
            flex: 3, // 3 parts out of 5 total parts
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: SizedBox(
                      width: double.infinity,
                      child: CandleStickGenerator(
                          onCandleDataGenerated: (candles) {
                        setState(() {
                          candleData.clear();
                          candleData.addAll(candles.map((c) => ICandle(
                              id: "0",
                              date: DateTime.now(),
                              open: c.open,
                              high: c.high,
                              low: c.low,
                              close: c.close,
                              volume: 10)));
                        });
                      })),
                ),
                // Flexible(
                //   flex: 1,
                //   child: SizedBox(
                //       width: double.infinity,
                //       child: CandleStickGenerator(
                //           onCandleDataGenerated: (candles) {
                //         setState(() {
                //           candleData.clear();
                //           candleData.addAll(candles.map((c) => ICandle(
                //               id: "0",
                //               date: DateTime.now(),
                //               open: c.open,
                //               high: c.high,
                //               low: c.low,
                //               close: c.close,
                //               volume: 10)));
                //         });
                //       })),
                // ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
