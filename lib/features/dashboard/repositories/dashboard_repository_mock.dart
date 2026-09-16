import "../../../core/utils/result.dart";
import "../entities/alert_entity.dart";
import "../entities/node_entity.dart";
import "../entities/summary_entity.dart";
import "dashboard_repository.dart";

/// Repository factice : memes signatures que DashboardRepositoryImpl, mais
/// renvoie des donnees en dur avec un petit delai simule. Pratique pour
/// developper les ecrans sans avoir le backend/docker lance.
/// Pour l'utiliser : dans main.dart, remplacer
///   DashboardRepositoryImpl(apiClient)
/// par
///   DashboardRepositoryMock()
class DashboardRepositoryMock implements DashboardRepository {
  final List<NodeEntity> _nodes = [
    NodeEntity(
      nodeId: "node-1",
      timestamp: DateTime.now(),
      online: true,
      productionKw: 6.2,
      consumptionKw: 4.1,
      distributedKw: 4.1,
    ),
    NodeEntity(
      nodeId: "node-2",
      timestamp: DateTime.now(),
      online: true,
      productionKw: 3.0,
      consumptionKw: 6.8,
      distributedKw: 3.0,
    ),
    NodeEntity(
      nodeId: "node-3",
      timestamp: DateTime.now(),
      online: false,
      productionKw: 0,
      consumptionKw: 0,
      distributedKw: 0,
    ),
    NodeEntity(
      nodeId: "node-4",
      timestamp: DateTime.now(),
      online: true,
      productionKw: 7.5,
      consumptionKw: 5.2,
      distributedKw: 5.2,
    ),
  ];

  Future<void> _simulateLatency() =>
      Future.delayed(const Duration(milliseconds: 400));

  @override
  Future<Result<List<NodeEntity>>> fetchNodes() async {
    await _simulateLatency();
    return Success(_nodes);
  }

  @override
  Future<Result<SummaryEntity>> fetchSummary() async {
    await _simulateLatency();
    final production = _nodes.fold<double>(0, (s, n) => s + n.productionKw);
    final consumption = _nodes.fold<double>(0, (s, n) => s + n.consumptionKw);

    return Success(SummaryEntity(
      totalProductionKw: production,
      totalConsumptionKw: consumption,
      balanceKw: production - consumption,
      nodesOnline: _nodes.where((n) => n.online).length,
      nodesTotal: _nodes.length,
      suggestions: const [
        RedistributionSuggestion(
          fromNode: "node-1",
          toNode: "node-2",
          suggestedKw: 2.1,
        ),
      ],
    ));
  }

  @override
  Future<Result<List<AlertEntity>>> fetchAlerts() async {
    await _simulateLatency();
    return Success([
      AlertEntity(
        nodeId: "node-2",
        timestamp: DateTime.now(),
        type: AlertType.overload,
        message: "Surcharge detectee sur node-2 : deficit de 3.80 kW.",
      ),
      AlertEntity(
        nodeId: "node-3",
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        type: AlertType.nodeOffline,
        message: "Le noeud node-3 ne repond plus.",
      ),
    ]);
  }

  @override
  Future<Result<List<NodeEntity>>> fetchNodeHistory(String nodeId, {int limit = 100}) async {
    await _simulateLatency();
    final base = _nodes.firstWhere(
      (n) => n.nodeId == nodeId,
      orElse: () => _nodes.first,
    );

    final now = DateTime.now();
    final history = List.generate(20, (i) {
      final noise = (i % 5) - 2; // petite variation reguliere pour un mock lisible
      return NodeEntity(
        nodeId: nodeId,
        timestamp: now.subtract(Duration(minutes: (20 - i) * 2)),
        online: true,
        productionKw: (base.productionKw + noise * 0.4).clamp(0.0, 20.0).toDouble(),
        consumptionKw: (base.consumptionKw - noise * 0.3).clamp(0.0, 20.0).toDouble(),
        distributedKw: base.distributedKw,
      );
    });

    return Success(history);
  }
}
