import "../entities/node_entity.dart";

/// Model = frontiere avec l'API. Seul cet objet sait que le backend envoie
/// "production_kw" en snake_case, un "timestamp" ISO8601, etc. Le reste de
/// l'app ne travaille qu'avec NodeEntity.
class NodeModel extends NodeEntity {
  const NodeModel({
    required super.nodeId,
    required super.timestamp,
    required super.online,
    required super.productionKw,
    required super.consumptionKw,
    required super.distributedKw,
  });

  factory NodeModel.fromJson(Map<String, dynamic> json) {
    return NodeModel(
      nodeId: json["node_id"] as String,
      timestamp: DateTime.tryParse(json["timestamp"] as String? ?? "") ??
          DateTime.now(),
      online: json["online"] as bool? ?? false,
      productionKw: (json["production_kw"] as num?)?.toDouble() ?? 0,
      consumptionKw: (json["consumption_kw"] as num?)?.toDouble() ?? 0,
      distributedKw: (json["distributed_kw"] as num?)?.toDouble() ?? 0,
    );
  }
}
