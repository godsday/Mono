import 'package:flutter/material.dart';
import 'package:mono/models/transcation_model/transcation_model.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../providers/app_state.dart';

class GraphWidget extends StatefulWidget {
  const GraphWidget({
    super.key,
    required TooltipBehavior tooltipBehavior,
    //required List<TranscationModel> chartData,
  }) : _tooltipBehavior = tooltipBehavior;

  final TooltipBehavior _tooltipBehavior;
  // final List<TranscationModel> _chartData;

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  @override
  Widget build(BuildContext context) {
    final List<Chartdata> expenseData = getChart(
        Provider.of<AppState>(context, listen: false)
            .expenselistnotifier
            .value);
    final List<Chartdata> incomeData = getChart(
        Provider.of<AppState>(context, listen: false).incomelistnotifier.value);
    final List<Chartdata> allData = getChart(
        Provider.of<AppState>(context, listen: false)
            .transcationNotifier
            .value);

    return Consumer<AppState>(builder: (context, provider, child) {
      return SfCircularChart(
        legend: const Legend(isVisible: true),
        tooltipBehavior: widget._tooltipBehavior,
        series: <CircularSeries>[
          DoughnutSeries<Chartdata, String>(
              dataSource: provider.itemvalue == 'All'
                  ? allData
                  : provider.itemvalue == 'Income'
                      ? incomeData
                      : expenseData,
              xValueMapper: (Chartdata data, _) => data.categories,
              yValueMapper: (Chartdata data, _) => data.amount,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              enableTooltip: true)
        ],
      );
    });
  }
}

List<Chartdata> getChart(List<TranscationModel> model) {
  double value;
  String catagoryname;
  List visted = [];
  List<Chartdata> thedata = [];

  for (var i = 0; i < model.length; i++) {
    visted.add(0);
  }

  for (var i = 0; i < model.length; i++) {
    value = model[i].amount;
    catagoryname = model[i].category;

    for (var j = i + 1; j < model.length; j++) {
      if (model[i].category == model[j].category) {
        value += model[j].amount;
        visted[j] = -1;
      }
    }

    if (visted[i] != -1) {
      thedata.add(Chartdata(categories: catagoryname, amount: value));
    }
  }
  return thedata;
}

class Chartdata {
  String? categories;
  double? amount;
  Chartdata({required this.categories, required this.amount});
}
