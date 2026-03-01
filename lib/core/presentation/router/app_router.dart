import 'package:flutter_starter_kit/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_starter_kit/features/product/presentation/screens/product_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  // Make the class singleton
  AppRouter._();

  static const loginPath = '/login';
  static const productPath = '/product';

  static final router = GoRouter(
    initialLocation: loginPath,
    routes: [
      GoRoute(
        path: loginPath,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: productPath,
        builder: (context, state) => const ProductScreen(),
      ),
      // Add more route here
    ],
  );
}
