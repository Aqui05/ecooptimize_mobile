/// Exception unifiee pour toutes les erreurs venant de la couche reseau.
/// Permet aux providers de distinguer un probleme reseau (backend down,
/// pas de connexion) d'une erreur serveur, sans exposer les details
/// techniques (SocketException, TimeoutException...) jusqu'a l'UI.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  factory ApiException.timeout() =>
      const ApiException("Le serveur met trop de temps a repondre.");

  factory ApiException.noConnection() =>
      const ApiException("Impossible de joindre le serveur. Verifiez la connexion.");

  factory ApiException.server(int statusCode) =>
      ApiException("Erreur serveur ($statusCode).", statusCode: statusCode);

  factory ApiException.parsing() =>
      const ApiException("Reponse du serveur illisible.");

  @override
  String toString() => message;
}
