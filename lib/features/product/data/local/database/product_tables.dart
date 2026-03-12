import 'package:drift/drift.dart';

class ProductEntries extends Table {
  IntColumn get id => integer()();

  TextColumn get title => text()();

  TextColumn get description => text()();

  TextColumn get category => text()();

  RealColumn get price => real()();

  RealColumn get discountPercentage => real()();

  RealColumn get rating => real()();

  IntColumn get stock => integer()();

  TextColumn get thumbnail => text()();

  TextColumn get imagesJson => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ProductCacheEntries extends Table {
  TextColumn get cacheKey => text()();

  IntColumn get total => integer()();

  IntColumn get skip => integer()();

  IntColumn get limit => integer()();

  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {cacheKey};
}
