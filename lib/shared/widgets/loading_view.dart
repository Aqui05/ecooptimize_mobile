import "package:flutter/material.dart";

/// Widgets generiques reutilisables par n'importe quelle feature (pas
/// specifiques au dashboard) -- c'est le critere pour vivre dans shared/
/// plutot que dans features/<x>/widgets/.
class LoadingView extends StatelessWidget {
  final String? message;

  const LoadingView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(message!),
          ],
        ],
      ),
    );
  }
}
