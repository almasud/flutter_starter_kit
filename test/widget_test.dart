import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter_kit/app.dart';
import 'package:flutter_starter_kit/core/di/injection.dart';
import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/auth/data/datasources/auth_datasource.dart';
import 'package:flutter_starter_kit/features/auth/data/local/session_storage.dart';
import 'package:flutter_starter_kit/features/auth/data/remote/model/dtos/auth_session_dto.dart';
import 'package:flutter_starter_kit/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_starter_kit/features/auth/domain/models/auth_session.dart';
import 'package:flutter_starter_kit/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_starter_kit/features/auth/domain/usecases/get_saved_session_usecase.dart';
import 'package:flutter_starter_kit/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_starter_kit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_starter_kit/features/product/data/datasources/product_datasource.dart';
import 'package:flutter_starter_kit/features/product/data/local/datasources/product_local_datasource.dart';
import 'package:flutter_starter_kit/features/product/data/local/model/cached_product_list_model.dart';
import 'package:flutter_starter_kit/features/product/data/remote/model/dtos/product_dto.dart';
import 'package:flutter_starter_kit/features/product/data/repositories/product_repository_impl.dart';
import 'package:flutter_starter_kit/features/product/domain/models/product_list.dart';
import 'package:flutter_starter_kit/features/product/domain/repositories/product_repository.dart';
import 'package:flutter_starter_kit/features/product/domain/usecases/get_cached_products_usecase.dart';
import 'package:flutter_starter_kit/features/product/domain/usecases/get_products_usecase.dart';
import 'package:flutter_starter_kit/features/product/domain/usecases/refresh_products_usecase.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_bloc.dart';

class _FakeProductDatasource extends ProductDatasource {
  @override
  Future<ApiResult<ProductDto, AppError>> getProducts() async {
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

class _FakeSessionStorage extends SessionStorage {
  @override
  Future<void> clear() async {}

  @override
  Future<AuthSession?> read() async => null;

  @override
  Future<void> save(AuthSession session) async {}
}

class _FakeProductLocalDatasource extends ProductLocalDatasource {
  @override
  Future<void> clearProducts() async {}

  @override
  Future<CachedProductListModel?> getCachedProducts() async => null;

  @override
  Future<void> saveProducts(
    ProductList products, {
    required DateTime fetchedAt,
  }) async {}
}

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerLazySingleton<SessionStorage>(() => _FakeSessionStorage());
    getIt.registerLazySingleton<AuthDatasource>(() => _FakeAuthDatasource());
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt(), getIt()),
    );
    getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));
    getIt.registerLazySingleton<GetSavedSessionUseCase>(
      () => GetSavedSessionUseCase(getIt()),
    );
    getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt()));
    getIt.registerLazySingleton<ProductLocalDatasource>(
      () => _FakeProductLocalDatasource(),
    );
    getIt.registerLazySingleton<ProductDatasource>(
      () => _FakeProductDatasource(),
    );
    getIt.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(getIt(), getIt()),
    );
    getIt.registerLazySingleton<GetProductsUseCase>(
      () => GetProductsUseCase(getIt()),
    );
    getIt.registerLazySingleton<GetCachedProductsUseCase>(
      () => GetCachedProductsUseCase(getIt()),
    );
    getIt.registerLazySingleton<RefreshProductsUseCase>(
      () => RefreshProductsUseCase(getIt()),
    );
    getIt.registerFactory<ProductBloc>(
      () => ProductBloc(getIt(), getIt(), getIt()),
    );
  });

  testWidgets('App renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const App(isAuthenticated: false));
    await tester.pump();

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
