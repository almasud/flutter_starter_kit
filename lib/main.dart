import 'package:flutter/cupertino.dart';
import 'package:flutter_starter_kit/app.dart';
import 'package:flutter_starter_kit/features/auth/domain/usecases/get_saved_session_usecase.dart';

import 'core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  final savedSession = await getIt<GetSavedSessionUseCase>()();
  runApp(App(isAuthenticated: savedSession != null));
}
