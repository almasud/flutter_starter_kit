import 'package:flutter_starter_kit/features/product/presentation/screens/product_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  // Make the class singleton
  AppRouter._();

  static final sample = "/product";

  static final router = GoRouter(
    initialLocation: sample,
      routes: [
        GoRoute(
            path: sample,
          builder: (context, state) => ProductScreen()
        ),
        // Add more route here
      ]
  );
}
