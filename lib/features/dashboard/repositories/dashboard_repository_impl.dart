import "../../../core/constants/app_constants.dart";
import "../../../core/network/api_client.dart";
import "../../../core/network/api_exception.dart";
import "../../../core/utils/result.dart";
import "../entities/alert_entity.dart";
import "../entities/node_entity.dart";
import "../entities/summary_entity.dart";
import "../models/alert_model.dart";
import "../models/node_model.dart";
import "../models/summary_model.dart";
import "dashboard_repository.dart";

class DashboardRepositoryImpl implements DashboardRepository {
  final ApiClient _client;

  DashboardRepositoryImpl(this._client);

  @override
  Future<Result<List<NodeEntity>>> fetchNodes() async {
    try {
      final json = await _client.getJson(AppConstants.nodesEndpoint) as List;
      final nodes = json
          .map((n) => NodeModel.fromJson(n as Map<String, dynamic>))
          .toList();
      return Success(nodes);
    } on ApiException catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<SummaryEntity>> fetchSummary() async {
    try {
      final json =
          await _client.getJson(AppConstants.summaryEndpoint) as Map<String, dynamic>;
      return Success(SummaryModel.fromJson(json));
    } on ApiException catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<List<AlertEntity>>> fetchAlerts() async {
    try {
      final json = await _client.getJson(AppConstants.alertsEndpoint) as List;
      final alerts = json
          .map((a) => AlertModel.fromJson(a as Map<String, dynamic>))
          .toList();
      return Success(alerts);
    } on ApiException catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<List<NodeEntity>>> fetchNodeHistory(String nodeId, {int limit = 100}) async {
    try {
      final path = "${AppConstants.nodeHistoryEndpoint(nodeId)}?limit=$limit";
      final json = await _client.getJson(path) as List;
      final history = json
          .map((n) => NodeModel.fromJson(n as Map<String, dynamic>))
          .toList();
      return Success(history);
    } on ApiException catch (e) {
      return Failure(e);
    }
  }
}
