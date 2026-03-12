import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../data/local/app_database.dart';
import '../../features/auth/data/datasources/auth_datasource.dart';
import '../../features/auth/data/local/session_storage.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_saved_session_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/product/data/datasources/product_datasource.dart';
import '../../features/product/data/local/database/product_dao.dart';
import '../../features/product/data/local/datasources/product_local_datasource.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/usecases/get_cached_products_usecase.dart';
import '../../features/product/domain/usecases/get_products_usecase.dart';
import '../../features/product/domain/usecases/refresh_products_usecase.dart';
import '../../features/product/presentation/bloc/product_bloc.dart';
import '../data/remote/dio_client.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Core
  getIt.registerLazySingleton(() => DioClient.create());
  getIt.registerLazySingleton(AppDatabase.new);
  getIt.registerLazySingleton(() => const FlutterSecureStorage());

  // Local Storage
  getIt.registerLazySingleton<SessionStorage>(
    () => SessionStorageImpl(getIt()),
  );
  getIt.registerLazySingleton(() => ProductDao(getIt()));
  getIt.registerLazySingleton<ProductLocalDatasource>(
    () => ProductLocalDatasourceImpl(getIt()),
  );

  // Auth Data Sources
  getIt.registerLazySingleton<AuthDatasource>(
    () => AuthDatasourceImpl(getIt()),
  );

  // Auth Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt(), getIt()),
  );

  // Auth Use cases
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton<GetSavedSessionUseCase>(
    () => GetSavedSessionUseCase(getIt()),
  );

  // Auth Blocs
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt()));

  // Data Sources
  getIt.registerLazySingleton<ProductDatasource>(
    () => ProductDatasourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt(), getIt()),
  );

  // Use cases
  getIt.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(getIt()),
  );
  getIt.registerLazySingleton<GetCachedProductsUseCase>(
    () => GetCachedProductsUseCase(getIt()),
  );
  getIt.registerLazySingleton<RefreshProductsUseCase>(
    () => RefreshProductsUseCase(getIt()),
  );

  // Blocs
  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(getIt(), getIt(), getIt()),
  );
}
