import 'package:fin_chart/fin_chart.dart';
import 'package:flutter/material.dart';

class AddDataDialog extends StatelessWidget {
  final Function(List<ICandle>) onDataUpdate;
  const AddDataDialog({super.key, required this.onDataUpdate});

  @override
  Widget build(BuildContext context) {
    List<ICandle> iCandleData = [];
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width - 20,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Add Data"),
            CandleStickGenerator(onCandleDataGenerated: (data) {
              iCandleData.clear();
              iCandleData.addAll(data
                  .map((c) => ICandle(
                      id: "0",
                      date: DateTime.now(),
                      open: c.open,
                      high: c.high,
                      low: c.low,
                      close: c.close,
                      volume: 100))
                  .toList());
            }),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onDataUpdate(iCandleData);
                  },
                  child: const Text("Submit")),
            )
          ],
        ),
      ),
    );
  }
}
