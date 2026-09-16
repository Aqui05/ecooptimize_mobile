import "../../../core/utils/result.dart";
import "../entities/alert_entity.dart";
import "../entities/node_entity.dart";
import "../entities/summary_entity.dart";

/// Contrat du repository. Le provider depend de cette abstraction, jamais
/// de DashboardRepositoryImpl directement -- ca permet de brancher un faux
/// repository (donnees mockees) pendant que le backend n'est pas dispo,
/// et de tester le provider sans reseau.
abstract class DashboardRepository {
  Future<Result<List<NodeEntity>>> fetchNodes();
  Future<Result<SummaryEntity>> fetchSummary();
  Future<Result<List<AlertEntity>>> fetchAlerts();
  Future<Result<List<NodeEntity>>> fetchNodeHistory(String nodeId, {int limit = 100});
}
