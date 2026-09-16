import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "core/network/api_client.dart";
import "core/theme/app_theme.dart";
import "features/dashboard/providers/dashboard_provider.dart";
import "features/dashboard/repositories/dashboard_repository.dart";
import "features/dashboard/repositories/dashboard_repository_impl.dart";
// import "features/dashboard/repositories/dashboard_repository_mock.dart";
import "features/dashboard/screens/dashboard_screen.dart";

void main() {
  runApp(const EcoOptimizeApp());
}

class EcoOptimizeApp extends StatelessWidget {
  const EcoOptimizeApp({super.key});

  // Un seul endroit a changer pour basculer entre le vrai backend et les
  // donnees mockees pendant le dev UI :
  //   DashboardRepository repository = DashboardRepositoryImpl(ApiClient());
  //   DashboardRepository repository = DashboardRepositoryMock();
  static DashboardRepository _buildRepository() {
    return DashboardRepositoryImpl(ApiClient());
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DashboardRepository>(
          create: (_) => _buildRepository(),
        ),
        ChangeNotifierProvider<DashboardProvider>(
          create: (context) => DashboardProvider(context.read<DashboardRepository>()),
        ),
      ],
      child: MaterialApp(
        title: "EcoOptimize",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const DashboardScreen(),
      ),
    );
  }
}
