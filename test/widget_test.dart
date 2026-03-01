// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_starter_kit/app.dart';
import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/core/di/injection.dart';
import 'package:flutter_starter_kit/core/presentation/router/auth_guard.dart';
import 'package:flutter_starter_kit/features/auth/data/datasources/auth_datasource.dart';
import 'package:flutter_starter_kit/features/auth/data/local/auth_session_store.dart';
import 'package:flutter_starter_kit/features/auth/data/remote/model/dtos/auth_session_dto.dart';
import 'package:flutter_starter_kit/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_starter_kit/features/auth/domain/models/auth_session.dart';
import 'package:flutter_starter_kit/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_starter_kit/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_starter_kit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_starter_kit/features/product/data/datasources/product_datasource.dart';
import 'package:flutter_starter_kit/features/product/data/remote/model/dtos/product_dto.dart';
import 'package:flutter_starter_kit/features/product/data/repositories/product_repository_impl.dart';
import 'package:flutter_starter_kit/features/product/domain/repositories/product_repository.dart';
import 'package:flutter_starter_kit/features/product/domain/usecases/get_products_usecase.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeProductDatasource extends ProductDatasource {
  @override
  Future<ApiResult<ProductDto, AppError>> getProducts({
    int skip = 0,
    int limit = 20,
    String query = '',
    String sortBy = 'title',
    String sortOrder = 'asc',
  }) async {
    return Success(
      ProductDto(products: const [], total: 0, skip: 0, limit: 30),
    );
  }
}

class _FakeAuthDatasource extends AuthDatasource {
  @override
  Future<ApiResult<AuthSessionDto, AppError>> login({
    required String username,
    required String password,
  }) async {
    return const Failure(UnauthorizedError(message: 'Invalid credentials'));
  }
}

class _InMemoryAuthSessionStore extends AuthSessionStore {
  AuthSession? _session;

  @override
  Future<void> clear() async {
    _session = null;
  }

  @override
  Future<AuthSession?> read() async {
    return _session;
  }

  @override
  Future<void> save(AuthSession session) async {
    _session = session;
  }
}

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerLazySingleton<AuthSessionStore>(
      () => _InMemoryAuthSessionStore(),
    );
    getIt.registerLazySingleton<AuthGuard>(() => AuthGuard(getIt()));
    getIt.registerLazySingleton<AuthDatasource>(() => _FakeAuthDatasource());
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));
    getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt(), getIt()));
    getIt.registerLazySingleton<ProductDatasource>(
      () => _FakeProductDatasource(),
    );
    getIt.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton<GetProductsUseCase>(
      () => GetProductsUseCase(getIt()),
    );
    getIt.registerFactory<ProductBloc>(() => ProductBloc(getIt()));
  });

  testWidgets('App renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pump();

    expect(find.text('Sign in to continue.'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
