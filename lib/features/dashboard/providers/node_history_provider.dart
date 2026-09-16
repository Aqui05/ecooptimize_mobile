import "package:flutter/foundation.dart";

import "../../../core/utils/result.dart";
import "../entities/node_entity.dart";
import "../repositories/dashboard_repository.dart";

enum HistoryStatus { initial, loading, success, error }

/// Provider separe de DashboardProvider : lifecycle different (ouvert/ferme
/// avec l'ecran d'historique d'un noeud precis), pas de polling necessaire
/// ici -- juste un chargement + un pull-to-refresh manuel.
class NodeHistoryProvider extends ChangeNotifier {
  final DashboardRepository _repository;
  final String nodeId;

  NodeHistoryProvider(this._repository, {required this.nodeId});

  HistoryStatus status = HistoryStatus.initial;
  String? errorMessage;
  List<NodeEntity> readings = [];

  bool get isLoading => status == HistoryStatus.loading;

  Future<void> load({int limit = 50}) async {
    status = HistoryStatus.loading;
    notifyListeners();

    final result = await _repository.fetchNodeHistory(nodeId, limit: limit);

    switch (result) {
      case Success(:final data):
        // L'API renvoie du plus recent au plus ancien ; pour un graphe
        // lisible de gauche a droite, on remet dans l'ordre chronologique.
        readings = data.reversed.toList();
        status = HistoryStatus.success;
        errorMessage = null;
      case Failure(:final error):
        status = HistoryStatus.error;
        errorMessage = error.message;
    }

    notifyListeners();
  }
}
