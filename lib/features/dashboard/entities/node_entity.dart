/// Entite domaine pure : represente un noeud (site de production/
/// consommation) tel que le reste de l'app le manipule, sans aucune
/// connaissance du format JSON renvoye par l'API. C'est ce que les
/// widgets et le provider utilisent.
class NodeEntity {
  final String nodeId;
  final DateTime timestamp;
  final bool online;
  final double productionKw;
  final double consumptionKw;
  final double distributedKw;

  const NodeEntity({
    required this.nodeId,
    required this.timestamp,
    required this.online,
    required this.productionKw,
    required this.consumptionKw,
    required this.distributedKw,
  });

  double get balanceKw => productionKw - consumptionKw;
  bool get isOverloaded => online && balanceKw < 0;
}
