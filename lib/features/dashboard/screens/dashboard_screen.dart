import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../../shared/widgets/error_view.dart";
import "../../../shared/widgets/loading_view.dart";
import "../providers/dashboard_provider.dart";
import "../widgets/alert_list_item.dart";
import "../widgets/node_card.dart";
import "../widgets/summary_header.dart";
import "node_history_screen.dart";

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // On lance le polling apres le premier frame pour eviter d'appeler
    // notifyListeners() pendant le build initial.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().start();
    });
  }

  // Pas de dispose() du provider ici : c'est Provider (via ChangeNotifierProvider)
  // qui gere son cycle de vie, voir main.dart.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EcoOptimize")),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, _) {
          if (provider.status == DashboardStatus.initial ||
              (provider.isLoading && provider.summary == null)) {
            return const LoadingView(message: "Chargement des donnees...");
          }

          if (provider.hasError && provider.summary == null) {
            return ErrorView(
              message: provider.errorMessage ?? "Une erreur est survenue.",
              onRetry: provider.refreshManually,
            );
          }

          return RefreshIndicator(
            onRefresh: provider.refreshManually,
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                if (provider.summary != null)
                  SummaryHeader(summary: provider.summary!),

                if (provider.alerts.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Text("Alertes récentes",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ...provider.alerts.map((a) => AlertListItem(alert: a)),
                ],

                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text("Noeuds",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ...provider.nodes.map((n) => NodeCard(
                      node: n,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NodeHistoryScreen(nodeId: n.nodeId),
                        ),
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
