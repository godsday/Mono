import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mono/l10n/app_localizations.dart';
import 'package:mono/core/utils/extension/context_extension.dart';
import '../../domain/entities/budget_discipline_data.dart';

class BudgetDisciplineChart extends StatelessWidget {
  final BudgetDisciplineData data;

  const BudgetDisciplineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.last6MonthsData.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.no_budget_data));
    }

    List<BarChartGroupData> groups = [];
    int index = 0;
    List<String> xLabels = [];

    double maxY = 0;

    data.last6MonthsData.forEach((month, values) {
      double budget = values['budget'] ?? 0;
      double actual = values['actual'] ?? 0;

      if (budget > maxY) maxY = budget;
      if (actual > maxY) maxY = actual;

      xLabels.add(month.split(' ')[0]); // Get just MMM

      groups.add(BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: budget,
            color: Colors.blue.withValues(alpha: 0.5),
            width: 12,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4), topRight: Radius.circular(4)),
          ),
          BarChartRodData(
            toY: actual,
            color: actual > budget ? Colors.red : Colors.green,
            width: 12,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4), topRight: Radius.circular(4)),
          ),
        ],
      ));
      index++;
    });

    maxY = maxY * 1.2; // 20% padding
    if (maxY == 0) maxY = 1000;

    return AspectRatio(
        aspectRatio: 1.6,
        child: BarChart(BarChartData(
          maxY: maxY,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final isBudget = rodIndex == 0;
              final l10n = AppLocalizations.of(context)!;
              return BarTooltipItem(
                '${isBudget ? l10n.budget_tooltip : l10n.spent_tooltip}${context.formatCurrency(rod.toY)}',
                const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              );
            }),
          ),
          titlesData: FlTitlesData(
              show: true,
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value >= xLabels.length) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            xLabels[value.toInt()],
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        );
                      }))),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withValues(alpha: 0.1),
              strokeWidth: 1,
            ),
          ),
          barGroups: groups,
        )));
  }
}
