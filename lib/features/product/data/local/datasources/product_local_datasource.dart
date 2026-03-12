import 'package:flutter_starter_kit/features/product/data/local/database/product_dao.dart';
import 'package:flutter_starter_kit/features/product/data/local/mappers/product_local_mapper.dart';
import 'package:flutter_starter_kit/features/product/data/local/model/cached_product_list_model.dart';
import 'package:flutter_starter_kit/features/product/domain/models/product_list.dart';

abstract class ProductLocalDatasource {
  Future<CachedProductListModel?> getCachedProducts();

  Future<void> saveProducts(
    ProductList products, {
    required DateTime fetchedAt,
  });

  Future<void> clearProducts();
}

class ProductLocalDatasourceImpl extends ProductLocalDatasource {
  ProductLocalDatasourceImpl(this._productDao);

  final ProductDao _productDao;

  @override
  Future<CachedProductListModel?> getCachedProducts() async {
    final meta = await _productDao.getProductCacheEntry('products');
    if (meta == null) {
      return null;
    }

    final rows = await _productDao.getProductEntries();
    final data = ProductList(
      products: rows.map((row) => row.toDomain()).toList(),
      total: meta.total,
      skip: meta.skip,
      limit: meta.limit,
    );

    return CachedProductListModel(data: data, fetchedAt: meta.fetchedAt);
  }

  @override
  Future<void> saveProducts(
    ProductList products, {
    required DateTime fetchedAt,
  }) {
    return _productDao.replaceProductCache(
      products: products.toCompanions(),
      meta: products.toMetaCompanion(fetchedAt),
    );
  }

  @override
  Future<void> clearProducts() {
    return _productDao.clearProductCache();
  }
}
