import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mono/l10n/app_localizations.dart';

class AssetAllocationChart extends StatefulWidget {
  final Map<String, double> allocation;

  const AssetAllocationChart({super.key, required this.allocation});

  @override
  State<AssetAllocationChart> createState() => _AssetAllocationChartState();
}

class _AssetAllocationChartState extends State<AssetAllocationChart> {
  int touchedIndex = -1;

  final List<Color> _colors = [
    const Color(0xFF5A67D8), // Indigo
    const Color(0xFF48BB78), // Green
    const Color(0xFFED8936), // Orange
    const Color(0xFFE53E3E), // Red
    const Color(0xFF3182CE), // Blue
    const Color(0xFFA0AEC0), // Grey
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.allocation.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.no_asset_data));
    }

    double total = widget.allocation.values.fold(0, (sum, val) => sum + val);

    List<PieChartSectionData> sections = [];
    int index = 0;

    widget.allocation.forEach((key, value) {
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 110.0 : 100.0;
      final fontSize = isTouched ? 16.0 : 12.0;
      final double percentage = total > 0 ? (value / total) * 100 : 0;

      sections.add(
        PieChartSectionData(
          color: _colors[index % _colors.length],
          value: value,
          title: '${percentage.toStringAsFixed(0)}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          badgeWidget: isTouched
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4)
                      ]),
                  child: Text(key,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                )
              : null,
          badgePositionPercentageOffset: 1.2,
        ),
      );
      index++;
    });

    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(show: false),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: sections,
        ),
      ),
    );
  }
}
