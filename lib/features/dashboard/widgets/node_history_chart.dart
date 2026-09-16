import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";

import "../../../core/theme/app_colors.dart";
import "../entities/node_entity.dart";

/// Graphique en ligne production vs consommation dans le temps.
/// Widget "bete" : ne recoit que des donnees deja pretes (readings),
/// aucune logique de fetch ici -- c'est NodeHistoryProvider qui s'en charge.
class NodeHistoryChart extends StatelessWidget {
  final List<NodeEntity> readings;

  const NodeHistoryChart({super.key, required this.readings});

  @override
  Widget build(BuildContext context) {
    if (readings.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text("Pas encore de données.")),
      );
    }

    final productionSpots = <FlSpot>[];
    final consumptionSpots = <FlSpot>[];

    for (var i = 0; i < readings.length; i++) {
      productionSpots.add(FlSpot(i.toDouble(), readings[i].productionKw));
      consumptionSpots.add(FlSpot(i.toDouble(), readings[i].consumptionKw));
    }

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 32),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            _line(productionSpots, AppColors.primary),
            _line(consumptionSpots, AppColors.secondary),
          ],
        ),
      ),
    );
  }

  LineChartBarData _line(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: true, color: color.withOpacity(0.08)),
    );
  }
}
