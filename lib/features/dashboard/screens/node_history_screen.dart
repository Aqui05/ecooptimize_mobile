import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

import "../../../shared/widgets/error_view.dart";
import "../../../shared/widgets/loading_view.dart";
import "../entities/node_entity.dart";
import "../providers/node_history_provider.dart";
import "../repositories/dashboard_repository.dart";
import "../widgets/node_history_chart.dart";

class NodeHistoryScreen extends StatelessWidget {
  final String nodeId;

  const NodeHistoryScreen({super.key, required this.nodeId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NodeHistoryProvider>(
      // Provider cree ici (pas dans main.dart) car son cycle de vie est
      // celui de l'ecran : un nouveau provider par noeud consulte, detruit
      // en sortant. On reutilise le DashboardRepository deja enregistre
      // plus haut dans l'arbre plutot que d'en recreer un.
      create: (context) => NodeHistoryProvider(
        context.read<DashboardRepository>(),
        nodeId: nodeId,
      )..load(),
      child: _NodeHistoryView(nodeId: nodeId),
    );
  }
}

class _NodeHistoryView extends StatelessWidget {
  final String nodeId;

  const _NodeHistoryView({required this.nodeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(nodeId)),
      body: Consumer<NodeHistoryProvider>(
        builder: (context, provider, _) {
          if (provider.status == HistoryStatus.initial || provider.isLoading) {
            return const LoadingView(message: "Chargement de l'historique...");
          }

          if (provider.status == HistoryStatus.error) {
            return ErrorView(
              message: provider.errorMessage ?? "Une erreur est survenue.",
              onRetry: provider.load,
            );
          }

          return RefreshIndicator(
            onRefresh: provider.load,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Production vs consommation",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                NodeHistoryChart(readings: provider.readings),
                const SizedBox(height: 24),
                const Text(
                  "Relevés détaillés",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...provider.readings.reversed.map(_readingRow),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _readingRow(NodeEntity reading) {
    return ListTile(
      dense: true,
      title: Text(
        "${reading.productionKw.toStringAsFixed(1)} kW prod · "
        "${reading.consumptionKw.toStringAsFixed(1)} kW conso",
      ),
      trailing: Text(DateFormat("HH:mm:ss").format(reading.timestamp)),
    );
  }
}
