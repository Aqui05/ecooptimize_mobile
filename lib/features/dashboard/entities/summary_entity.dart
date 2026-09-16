class RedistributionSuggestion {
  final String fromNode;
  final String toNode;
  final double suggestedKw;

  const RedistributionSuggestion({
    required this.fromNode,
    required this.toNode,
    required this.suggestedKw,
  });
}

class SummaryEntity {
  final double totalProductionKw;
  final double totalConsumptionKw;
  final double balanceKw;
  final int nodesOnline;
  final int nodesTotal;
  final List<RedistributionSuggestion> suggestions;

  const SummaryEntity({
    required this.totalProductionKw,
    required this.totalConsumptionKw,
    required this.balanceKw,
    required this.nodesOnline,
    required this.nodesTotal,
    required this.suggestions,
  });
}
