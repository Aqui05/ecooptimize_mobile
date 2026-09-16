import "package:flutter/material.dart";

/// Palette centralisee. Ne jamais ecrire de Color(0x..) directement dans un
/// widget : passer par ici pour garder une identite visuelle coherente et
/// pouvoir la faire evoluer (ex: theme sombre) depuis un seul endroit.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1B8A5A);      // vert energie
  static const Color primaryDark = Color(0xFF126B44);
  static const Color secondary = Color(0xFF2E7DD1);    // bleu distribution

  static const Color background = Color(0xFFF5F7F8);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF1A1F1D);
  static const Color textSecondary = Color(0xFF6B7570);

  static const Color success = Color(0xFF2E9E5B);
  static const Color warning = Color(0xFFE0A100);
  static const Color danger = Color(0xFFD34C4C);
  static const Color offline = Color(0xFF9AA0A6);
}
