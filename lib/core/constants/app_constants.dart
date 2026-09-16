/// Constantes globales de l'application.
/// Regroupe tout ce qui est "en dur" pour eviter les valeurs magiques
/// eparpillees dans le code (URLs, timeouts, intervalles de rafraichissement).
class AppConstants {
  AppConstants._(); // pas d'instanciation

  // --- API ---
  // On cible localhost:4000 directement (web, desktop, iOS simulator, ou
  // Android avec `adb reverse tcp:4000 tcp:4000` pour un appareil physique).
  // Seul l'emulateur Android classique a besoin de l'alias 10.0.2.2 --
  // si c'est ton cas, remplace juste cette ligne.
  static const String apiBaseUrl = "http://localhost:4000";

  static const String nodesEndpoint = "/api/nodes";
  static const String summaryEndpoint = "/api/summary";
  static const String alertsEndpoint = "/api/alerts";
  static const String healthEndpoint = "/health";
  static String nodeHistoryEndpoint(String nodeId) => "/api/nodes/$nodeId/history";

  // --- Timings ---
  static const Duration apiTimeout = Duration(seconds: 8);
  static const Duration dashboardRefreshInterval = Duration(seconds: 5);

  // --- Seuils d'affichage (doivent rester coherents avec le backend) ---
  static const double overloadThresholdKw = 2.0;
}
