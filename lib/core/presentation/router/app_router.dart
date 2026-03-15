import 'package:flutter_starter_kit/core/di/injection.dart';
import 'package:flutter_starter_kit/core/presentation/router/auth_guard.dart';
import 'package:flutter_starter_kit/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_starter_kit/features/product/presentation/screens/product_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static const loginPath = '/login';
  static const productPath = '/product';

  static final router = GoRouter(
    initialLocation: loginPath,
    refreshListenable: getIt<AuthGuard>(),
    redirect: (context, state) {
      final isLoggedIn = getIt<AuthGuard>().isAuthenticated;
      final isOnLogin = state.matchedLocation == loginPath;

      if (!isLoggedIn && !isOnLogin) return loginPath;
      if (isLoggedIn && isOnLogin) return productPath;
      return null;
    },
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
