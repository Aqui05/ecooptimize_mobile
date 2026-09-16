enum AlertType { overload, nodeOffline, unknown }

class AlertEntity {
  final String nodeId;
  final DateTime timestamp;
  final AlertType type;
  final String message;

  const AlertEntity({
    required this.nodeId,
    required this.timestamp,
    required this.type,
    required this.message,
  });
}
