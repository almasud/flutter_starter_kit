// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dao.dart';

// ignore_for_file: type=lint
mixin _$ProductDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProductEntriesTable get productEntries => attachedDatabase.productEntries;
  $ProductCacheEntriesTable get productCacheEntries =>
      attachedDatabase.productCacheEntries;
  ProductDaoManager get managers => ProductDaoManager(this);
}

class ProductDaoManager {
  final _$ProductDaoMixin _db;
  ProductDaoManager(this._db);
  $$ProductEntriesTableTableManager get productEntries =>
      $$ProductEntriesTableTableManager(
        _db.attachedDatabase,
        _db.productEntries,
      );
  $$ProductCacheEntriesTableTableManager get productCacheEntries =>
      $$ProductCacheEntriesTableTableManager(
        _db.attachedDatabase,
        _db.productCacheEntries,
      );
}
