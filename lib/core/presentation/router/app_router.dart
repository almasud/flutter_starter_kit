import 'package:flutter_starter_kit/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_starter_kit/features/product/presentation/screens/product_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static const loginPath = '/login';
  static const productPath = '/product';

  static GoRouter createRouter({required bool isAuthenticated}) {
    return GoRouter(
      initialLocation: isAuthenticated ? productPath : loginPath,
      routes: [
        GoRoute(
          path: loginPath,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: productPath,
          builder: (context, state) => const ProductScreen(),
        ),
      ],
    );
  }
}
