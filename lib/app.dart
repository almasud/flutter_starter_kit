import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/constants/app_strings.dart';
import 'package:flutter_starter_kit/core/router/app_router.dart';

import 'core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
