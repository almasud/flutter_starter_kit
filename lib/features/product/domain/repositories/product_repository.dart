import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/product/domain/models/cached_product_list.dart';

abstract class ProductRepository {
  Future<CachedProductList?> getCachedProducts();

  Future<ApiResult<CachedProductList, AppError>> refreshProducts();
}
