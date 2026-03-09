import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mono/l10n/app_localizations.dart';

class ExpenseTrendChart extends StatelessWidget {
  final Map<String, double> data;

  const ExpenseTrendChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.no_expense_data));
    }

    List<FlSpot> spots = [];
    int index = 0;
    List<String> xLabels = [];

    double maxY = 0;

    data.forEach((month, expense) {
      spots.add(FlSpot(index.toDouble(), expense));
      xLabels.add(month);
      if (expense > maxY) maxY = expense;
      index++;
    });

    maxY = maxY * 1.2;
    if (maxY == 0) maxY = 1000;

    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
            minX: 0,
            maxX: spots.length.toDouble() - 1,
            minY: 0,
            maxY: maxY,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.redAccent,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      Colors.redAccent.withValues(alpha: 0.3),
                      Colors.redAccent.withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
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
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    );
                  },
                  interval: 1,
                ),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.withValues(alpha: 0.1),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            lineTouchData: LineTouchData(
              touchTooltipData:
                  LineTouchTooltipData(getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '₹${spot.y.toStringAsFixed(0)}',
                    const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  );
                }).toList();
              }),
            )),
      ),
    );
  }
}
