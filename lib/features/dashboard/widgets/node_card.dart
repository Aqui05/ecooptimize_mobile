import "package:flutter/material.dart";

import "../../../core/theme/app_colors.dart";
import "../../../core/theme/app_text_styles.dart";
import "../entities/node_entity.dart";

class NodeCard extends StatelessWidget {
  final NodeEntity node;
  final VoidCallback? onTap;

  const NodeCard({super.key, required this.node, this.onTap});

  Color get _statusColor {
    if (!node.online) return AppColors.offline;
    return node.isOverloaded ? AppColors.danger : AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _statusColor.withOpacity(0.15),
          child: Icon(Icons.bolt, color: _statusColor),
        ),
        title: Text(node.nodeId, style: AppTextStyles.heading2),
        subtitle: Text(
          node.online
              ? "Prod ${node.productionKw.toStringAsFixed(1)} kW · "
                  "Conso ${node.consumptionKw.toStringAsFixed(1)} kW"
              : "Hors ligne",
          style: AppTextStyles.caption,
        ),
        trailing: node.online
            ? Text(
                "${node.balanceKw >= 0 ? '+' : ''}${node.balanceKw.toStringAsFixed(1)} kW",
                style: AppTextStyles.body.copyWith(
                  color: _statusColor,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
    );
  }
}
