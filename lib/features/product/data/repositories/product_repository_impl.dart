import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/product/data/datasources/product_datasource.dart';
import 'package:flutter_starter_kit/features/product/data/local/datasources/product_local_datasource.dart';
import 'package:flutter_starter_kit/features/product/data/mappers/product_mapper.dart';
import 'package:flutter_starter_kit/features/product/domain/models/cached_product_list.dart';
import 'package:flutter_starter_kit/features/product/domain/models/product_list.dart';
import 'package:flutter_starter_kit/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl extends ProductRepository {
  ProductRepositoryImpl(this._datasource, this._localDatasource);

  final ProductDatasource _datasource;
  final ProductLocalDatasource _localDatasource;

  @override
  Future<CachedProductList?> getCachedProducts() async {
    final cached = await _localDatasource.getCachedProducts();
    if (cached == null) {
      return null;
    }

    return CachedProductList(data: cached.data, fetchedAt: cached.fetchedAt);
  }

  @override
  Future<ApiResult<CachedProductList, AppError>> refreshProducts() async {
    final result = await _datasource.getProducts();

    switch (result) {
      case Success(:final data):
        final productList = data.toDomain();
        final fetchedAt = DateTime.now();
        await _localDatasource.saveProducts(productList, fetchedAt: fetchedAt);
        return Success(
          CachedProductList(data: productList, fetchedAt: fetchedAt),
        );
      case Failure(:final error):
        return Failure(error);
    }
  }

  @override
  Future<ApiResult<ProductList, AppError>> getProducts({
    int skip = 0,
    int limit = 20,
    String query = '',
    String sortBy = 'title',
    String sortOrder = 'asc',
  }) async {
    final result = await _datasource.getProducts(
      skip: skip,
      limit: limit,
      query: query,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
    return result.map((dto) => dto.toDomain());
  }
}
