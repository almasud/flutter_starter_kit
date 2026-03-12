import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_starter_kit/features/product/data/local/database/product_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [ProductEntries, ProductCacheEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'app_database');
}
