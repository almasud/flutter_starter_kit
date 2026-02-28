import 'package:flutter_starter_kit/features/sample/presentation/screens/sample_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  // Make the class singleton
  AppRouter._();

  static final sample = "/sample";

  static final router = GoRouter(
    initialLocation: sample,
      routes: [
        GoRoute(
            path: sample,
          builder: (context, state) => SampleScreen()
        ),
        // Add more route here
      ]
  );
}
