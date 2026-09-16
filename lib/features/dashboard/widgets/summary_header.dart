import "package:flutter/material.dart";

import "../../../core/theme/app_colors.dart";
import "../../../core/theme/app_text_styles.dart";
import "../entities/summary_entity.dart";

class SummaryHeader extends StatelessWidget {
  final SummaryEntity summary;

  const SummaryHeader({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final isBalanced = summary.balanceKw >= 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _metric("Production", summary.totalProductionKw, AppColors.primary),
                _metric("Consommation", summary.totalConsumptionKw, AppColors.secondary),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  isBalanced ? Icons.check_circle : Icons.warning_amber_rounded,
                  color: isBalanced ? AppColors.success : AppColors.warning,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  "Balance : ${summary.balanceKw.toStringAsFixed(2)} kW",
                  style: AppTextStyles.body,
                ),
                const Spacer(),
                Text(
                  "${summary.nodesOnline}/${summary.nodesTotal} noeuds en ligne",
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metric(String label, double valueKw, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text(
          "${valueKw.toStringAsFixed(1)} kW",
          style: AppTextStyles.metricValue.copyWith(color: color),
        ),
      ],
    );
  }
}
