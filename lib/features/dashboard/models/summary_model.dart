import "../entities/summary_entity.dart";

class SummaryModel extends SummaryEntity {
  const SummaryModel({
    required super.totalProductionKw,
    required super.totalConsumptionKw,
    required super.balanceKw,
    required super.nodesOnline,
    required super.nodesTotal,
    required super.suggestions,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    final rawSuggestions = json["redistribution_suggestions"] as List? ?? [];

    return SummaryModel(
      totalProductionKw: (json["total_production_kw"] as num?)?.toDouble() ?? 0,
      totalConsumptionKw: (json["total_consumption_kw"] as num?)?.toDouble() ?? 0,
      balanceKw: (json["balance_kw"] as num?)?.toDouble() ?? 0,
      nodesOnline: json["nodes_online"] as int? ?? 0,
      nodesTotal: json["nodes_total"] as int? ?? 0,
      suggestions: rawSuggestions
          .map((s) => RedistributionSuggestion(
                fromNode: s["from_node"] as String,
                toNode: s["to_node"] as String,
                suggestedKw: (s["suggested_kw"] as num).toDouble(),
              ))
          .toList(),
    );
  }
}
