import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdvancedChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String title;
  final ChartType chartType;

  const AdvancedChart({
    super.key,
    required this.data,
    required this.title,
    this.chartType = ChartType.bar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: chartType == ChartType.bar
                  ? _buildBarChart()
                  : _buildPieChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        barGroups: _getBarGroups(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < data.length) {
                  final label = data[value.toInt()]['label'] as String;
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        maxY: _getMaxYValue(),
      ),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: _getPieSections(),
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(data.length, (i) {
      final item = data[i];
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: item['value'] as double,
            color: item['color'] as Color,
            width: 16,
            borderRadius: BorderRadius.zero,
          ),
        ],
      );
    });
  }

  List<PieChartSectionData> _getPieSections() {
    return List.generate(data.length, (i) {
      final item = data[i];
      final isTouched = i == 0;
      final fontSize = isTouched ? 16.0 : 14.0;
      final radius = isTouched ? 50.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: item['color'],
        value: item['value'],
        title: '${item['percentage']}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }

  double _getMaxYValue() {
    if (data.isEmpty) return 1;
    final values = data.map((item) => item['value'] as double).toList();
    return values.reduce((a, b) => a > b ? a : b) * 1.2;
  }
}

enum ChartType { bar, pie }