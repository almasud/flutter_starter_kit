import 'package:drift/drift.dart';
import 'package:flutter_starter_kit/core/data/local/app_database.dart';
import 'package:flutter_starter_kit/features/product/data/local/database/product_tables.dart';

part 'product_dao.g.dart';

@DriftAccessor(tables: [ProductEntries, ProductCacheEntries])
class ProductDao extends DatabaseAccessor<AppDatabase> with _$ProductDaoMixin {
  ProductDao(super.db);

  Future<List<ProductEntry>> getProductEntries() {
    return (select(
      productEntries,
    )..orderBy([(table) => OrderingTerm.asc(table.id)])).get();
  }

  Future<ProductCacheEntry?> getProductCacheEntry(String key) {
    return (select(
      productCacheEntries,
    )..where((table) => table.cacheKey.equals(key))).getSingleOrNull();
  }

  Future<void> replaceProductCache({
    required List<ProductEntriesCompanion> products,
    required ProductCacheEntriesCompanion meta,
  }) {
    return transaction(() async {
      await delete(productEntries).go();
      await batch((batch) {
        batch.insertAll(productEntries, products);
      });
      await into(productCacheEntries).insertOnConflictUpdate(meta);
    });
  }

  Future<void> clearProductCache() {
    return transaction(() async {
      await delete(productEntries).go();
      await delete(productCacheEntries).go();
    });
  }
}
