import 'package:flutter/cupertino.dart';
import 'package:flutter_starter_kit/app.dart';

import 'core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(App());
}
