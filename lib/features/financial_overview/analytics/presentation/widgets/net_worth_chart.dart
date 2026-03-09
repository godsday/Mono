import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/l10n/app_localizations.dart';
import 'package:mono/core/utils/extension/context_extension.dart';
import '../../domain/entities/net_worth_data.dart';

class NetWorthChart extends StatelessWidget {
  final NetWorthData data;

  const NetWorthChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.historyLast6Months.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.no_data_available));
    }

    List<FlSpot> spots = [];
    int index = 0;
    List<String> xLabels = [];

    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    data.historyLast6Months.forEach((date, value) {
      spots.add(FlSpot(index.toDouble(), value));
      xLabels.add(DateFormat('MMM').format(date));
      if (value < minY) minY = value;
      if (value > maxY) maxY = value;
      index++;
    });

    // Add padding to Y axis
    double yPadding = (maxY - minY) * 0.2;
    if (yPadding == 0) yPadding = maxY * 0.2;
    if (yPadding == 0) yPadding = 1000;

    minY = minY - yPadding;
    maxY = maxY + yPadding;

    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
            minX: 0,
            maxX: spots.length.toDouble() - 1,
            minY: minY,
            maxY: maxY,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: AppColor.greenText,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColor.greenText.withValues(alpha: 0.1),
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
                    context.formatCurrency(spot.y),
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
