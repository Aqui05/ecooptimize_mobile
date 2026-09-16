import "dart:async";

import "package:flutter/foundation.dart";

import "../../../core/constants/app_constants.dart";
import "../../../core/network/api_exception.dart";
import "../../../core/utils/result.dart";
import "../entities/alert_entity.dart";
import "../entities/node_entity.dart";
import "../entities/summary_entity.dart";
import "../repositories/dashboard_repository.dart";

enum DashboardStatus { initial, loading, success, error }

/// Etat + logique de presentation de l'ecran dashboard.
/// - Ne connait que DashboardRepository (interface) : swap facile entre
///   l'implementation reelle et le mock (voir main.dart).
/// - Fait du polling automatique pour simuler le "temps reel" sans
///   dependance a un WebSocket cote backend.
/// - Toute erreur reseau devient un message affichable, jamais une
///   exception qui remonte jusqu'au widget.
class DashboardProvider extends ChangeNotifier {
  final DashboardRepository _repository;
  Timer? _pollingTimer;

  DashboardProvider(this._repository);

  DashboardStatus status = DashboardStatus.initial;
  String? errorMessage;

  List<NodeEntity> nodes = [];
  SummaryEntity? summary;
  List<AlertEntity> alerts = [];

  bool get isLoading => status == DashboardStatus.loading;
  bool get hasError => status == DashboardStatus.error;

  /// A appeler depuis initState() de l'ecran.
  void start() {
    _refresh();
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      AppConstants.dashboardRefreshInterval,
      (_) => _refresh(silent: true),
    );
  }

  /// A appeler depuis dispose() de l'ecran, sinon le Timer continue de
  /// tourner apres la fermeture de l'ecran (fuite memoire classique).
  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> refreshManually() => _refresh();

  Future<void> _refresh({bool silent = false}) async {
    if (!silent) {
      status = DashboardStatus.loading;
      notifyListeners();
    }

    final results = await Future.wait([
      _repository.fetchSummary(),
      _repository.fetchNodes(),
      _repository.fetchAlerts(),
    ]);

    final summaryResult = results[0] as Result<SummaryEntity>;
    final nodesResult = results[1] as Result<List<NodeEntity>>;
    final alertsResult = results[2] as Result<List<AlertEntity>>;

    // Strategie de resilience simple : si au moins une requete reussit, on
    // affiche ce qu'on a plutot que de tout bloquer sur l'echec d'un seul
    // endpoint (ex : /api/alerts down ne doit pas empecher de voir /summary).
    if (summaryResult is Success<SummaryEntity>) summary = summaryResult.data;
    if (nodesResult is Success<List<NodeEntity>>) nodes = nodesResult.data;
    if (alertsResult is Success<List<AlertEntity>>) alerts = alertsResult.data;

    final allFailed = summaryResult is Failure &&
        nodesResult is Failure &&
        alertsResult is Failure;

    if (allFailed) {
      final firstError = (summaryResult as Failure<SummaryEntity>).error;
      status = DashboardStatus.error;
      errorMessage = _friendlyMessage(firstError);
    } else {
      status = DashboardStatus.success;
      errorMessage = null;
    }

    notifyListeners();
  }

  String _friendlyMessage(ApiException error) => error.message;
}
