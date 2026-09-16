# EcoOptimize — App mobile

Dashboard Flutter consommant l'API REST du [backend EcoOptimize](../ecooptimize)
pour visualiser en temps réel la production, la consommation et les alertes
d'un réseau de capteurs énergétiques.

## Démo

> À compléter : glisser ici une capture d'écran ou un GIF de l'app
> (voir la section [Enregistrer une démo](#enregistrer-une-démo) plus bas).
>
> `![Démo](docs/screenshots/demo.gif)`

## Architecture

Architecture en couches par feature, pour rester lisible et testable même
si l'app grossit :

```
lib/
  core/
    constants/    → URLs API, timeouts, seuils d'affichage
    theme/        → couleurs, styles de texte, ThemeData
    network/      → client HTTP unique + exceptions réseau
    utils/        → Result<T> (Success/Failure) pour propager les erreurs
  features/dashboard/
    entities/     → objets du domaine, indépendants du JSON de l'API
    models/       → parsing JSON -> entité (seule couche qui connaît le format API)
    repositories/ → interface + implémentation HTTP + mock (données factices)
    providers/    → état + logique de présentation (ChangeNotifier)
    screens/      → DashboardScreen, NodeHistoryScreen
    widgets/      → composants réutilisables de la feature
  shared/widgets/ → composants génériques (LoadingView, ErrorView)
  main.dart       → injection de dépendances
```

**Principe directeur** : les widgets ne parlent qu'aux providers, les
providers ne parlent qu'aux repositories (interfaces), et seule
`DashboardRepositoryImpl` connaît l'existence du réseau. Ça permet de
brancher `DashboardRepositoryMock` à la place de l'implémentation réelle
(un seul endroit à changer, dans `main.dart`) pour développer l'UI sans
backend lancé.

## Écrans

- **DashboardScreen** — vue d'ensemble : production/consommation totales,
  alertes récentes, liste des noeuds avec leur état. Rafraîchissement
  automatique toutes les 5 secondes (polling), pull-to-refresh manuel.
- **NodeHistoryScreen** — accessible en tapant sur un noeud : graphique
  production vs consommation dans le temps + relevés détaillés.

## Lancer l'app

Le backend doit tourner sur `localhost:4000` (voir le
[README du backend](../ecooptimize/README.md#sans-docker-développement-rapide) :
`./scripts/dev_up.sh` pour démarrer sans Docker, ou `docker compose up`).

```bash
flutter pub get
flutter run
```

`AppConstants.apiBaseUrl` (dans `lib/core/constants/app_constants.dart`)
pointe sur `http://localhost:4000`. Ça fonctionne tel quel sur Flutter web,
desktop, et l'iOS simulator. Pour un **émulateur Android classique**,
remplacer par `http://10.0.2.2:4000` (alias vers l'hôte). Pour un
**appareil Android physique**, garder `localhost` et faire :

```bash
adb reverse tcp:4000 tcp:4000
```

## Développer sans backend lancé

Dans `main.dart`, méthode `_buildRepository()` :

```dart
// return DashboardRepositoryImpl(ApiClient());
return DashboardRepositoryMock();
```

`DashboardRepositoryMock` renvoie des données factices avec un léger délai
simulé — pratique pour avancer sur l'UI indépendamment du backend.

## Enregistrer une démo

Une fois l'app lancée (émulateur ou appareil) :

1. **Android** : `Ctrl+Shift+P` (VS Code) → *Flutter: Screen Record*, ou
   `adb shell screenrecord /sdcard/demo.mp4` puis `adb pull`.
2. **iOS simulator** : `xcrun simctl io booted recordVideo docs/screenshots/demo.mov`.
3. Convertir en GIF léger pour le README (ex. avec `ffmpeg`) :
   ```bash
   ffmpeg -i demo.mov -vf "fps=12,scale=360:-1" docs/screenshots/demo.gif
   ```
4. Placer le fichier dans `docs/screenshots/` et décommenter la ligne dans
   la section [Démo](#démo) ci-dessus.

## Prochaines étapes

- Thème sombre
- Tests widgets sur `DashboardScreen` (avec `DashboardRepositoryMock`)
- Notifications push locales sur alerte de surcharge
