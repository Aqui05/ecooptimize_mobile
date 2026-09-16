import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../../../core/theme/app_colors.dart";
import "../../../core/theme/app_text_styles.dart";
import "../entities/alert_entity.dart";

class AlertListItem extends StatelessWidget {
  final AlertEntity alert;

  const AlertListItem({super.key, required this.alert});

  IconData get _icon {
    switch (alert.type) {
      case AlertType.overload:
        return Icons.flash_on;
      case AlertType.nodeOffline:
        return Icons.wifi_off;
      case AlertType.unknown:
        return Icons.info_outline;
    }
  }

  Color get _color {
    switch (alert.type) {
      case AlertType.overload:
        return AppColors.danger;
      case AlertType.nodeOffline:
        return AppColors.offline;
      case AlertType.unknown:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(_icon, color: _color),
      title: Text(alert.message, style: AppTextStyles.body),
      subtitle: Text(
        DateFormat("HH:mm:ss").format(alert.timestamp),
        style: AppTextStyles.caption,
      ),
    );
  }
}
