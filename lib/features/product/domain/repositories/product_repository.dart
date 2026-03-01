import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/product/domain/models/product_list.dart';

abstract class ProductRepository {
  Future<ApiResult<ProductList, AppError>> getProducts();
}
