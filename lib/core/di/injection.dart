import 'package:get_it/get_it.dart';

import '../../features/product/data/datasources/product_datasource.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/usecases/get_products_usecase.dart';
import '../../features/product/presentation/bloc/product_bloc.dart';
import '../data/remote/dio_client.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Core
  getIt.registerLazySingleton(() => DioClient.create());

  // Data Sources
  getIt.registerLazySingleton<ProductDatasource>(() => ProductDatasourceImpl(getIt()));

  // Repositories
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(getIt()));

  // Use cases
  getIt.registerLazySingleton<GetProductsUseCase>(() => GetProductsUseCase(getIt()));

  // Blocs
  getIt.registerFactory<ProductBloc>(() => ProductBloc(getIt()));
}
