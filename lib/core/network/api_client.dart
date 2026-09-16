import "dart:async";
import "dart:convert";
import "dart:io";

import "package:http/http.dart" as http;

import "../constants/app_constants.dart";
import "api_exception.dart";

/// Client HTTP unique de l'app. Toute la logique de bas niveau (base URL,
/// timeout, decodage JSON, mapping des erreurs) vit ici -- les repositories
/// ne manipulent jamais `http` directement, seulement ce client.
/// Ca centralise la resilience (un seul endroit a durcir : retry, cache,
/// changement d'URL de base...) et rend les repositories faciles a tester
/// (il suffit de mocker ApiClient).
class ApiClient {
  final http.Client _http;
  final String baseUrl;

  ApiClient({http.Client? httpClient, this.baseUrl = AppConstants.apiBaseUrl})
      : _http = httpClient ?? http.Client();

  Future<dynamic> getJson(String path) async {
    final uri = Uri.parse("$baseUrl$path");

    try {
      final response = await _http.get(uri).timeout(AppConstants.apiTimeout);
      return _decode(response);
    } on TimeoutException {
      throw ApiException.timeout();
    } on SocketException {
      throw ApiException.noConnection();
    } on FormatException {
      throw ApiException.parsing();
    }
  }

  dynamic _decode(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException.server(response.statusCode);
    }
    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }

  void dispose() => _http.close();
}
