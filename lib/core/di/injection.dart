import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../presentation/router/auth_guard.dart';
import '../../features/auth/data/datasources/auth_datasource.dart';
import '../../features/auth/data/local/auth_session_store.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/product/data/datasources/product_datasource.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/usecases/get_products_usecase.dart';
import '../../features/product/presentation/bloc/product_bloc.dart';
import '../data/remote/dio_client.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Core
  getIt.registerLazySingleton(() => const FlutterSecureStorage());
  getIt.registerLazySingleton(() => DioClient.create());
  getIt.registerLazySingleton<AuthSessionStore>(
    () => SecureAuthSessionStore(getIt()),
  );
  getIt.registerLazySingleton<AuthGuard>(() => AuthGuard(getIt()));

  // Auth Data Sources
  getIt.registerLazySingleton<AuthDatasource>(
    () => AuthDatasourceImpl(getIt()),
  );

  // Auth Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );

  // Auth Use cases
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));

  // Auth Blocs
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt(), getIt()));

  // Data Sources
  getIt.registerLazySingleton<ProductDatasource>(
    () => ProductDatasourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(getIt()),
  );

  // Blocs
  getIt.registerFactory<ProductBloc>(() => ProductBloc(getIt()));

  await getIt<AuthGuard>().restore();
}
