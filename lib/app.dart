import 'package:flutter/material.dart';

import 'core/presentation/constants/app_strings.dart';
import 'core/presentation/router/app_router.dart';
import 'core/presentation/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({required this.isAuthenticated, super.key});

  final bool isAuthenticated;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.createRouter(isAuthenticated: isAuthenticated),
    );
  }
}
