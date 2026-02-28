import 'package:get_it/get_it.dart';

import '../data/remote/dio_client.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Core
  getIt.registerLazySingleton(() => DioClient.create());
}