import "../entities/alert_entity.dart";

class AlertModel extends AlertEntity {
  const AlertModel({
    required super.nodeId,
    required super.timestamp,
    required super.type,
    required super.message,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      nodeId: json["node_id"] as String,
      timestamp: DateTime.tryParse(json["timestamp"] as String? ?? "") ??
          DateTime.now(),
      type: _parseType(json["type"] as String?),
      message: json["message"] as String? ?? "",
    );
  }

  static AlertType _parseType(String? raw) {
    switch (raw) {
      case "overload":
        return AlertType.overload;
      case "node_offline":
        return AlertType.nodeOffline;
      default:
        return AlertType.unknown;
    }
  }
}
