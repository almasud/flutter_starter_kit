import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/product/domain/models/cached_product_list.dart';
import 'package:flutter_starter_kit/features/product/domain/models/product_list.dart';

abstract class ProductRepository {
  Future<CachedProductList?> getCachedProducts();

  Future<ApiResult<CachedProductList, AppError>> refreshProducts();

  Future<ApiResult<ProductList, AppError>> getProducts({
    int skip = 0,
    int limit = 20,
    String query = '',
    String sortBy = 'title',
    String sortOrder = 'asc',
  });
}
