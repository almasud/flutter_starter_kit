import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/product/domain/models/cached_product_list.dart';
import 'package:flutter_starter_kit/features/product/domain/repositories/product_repository.dart';

class RefreshProductsUseCase {
  const RefreshProductsUseCase(this._repository);

  final ProductRepository _repository;

  Future<ApiResult<CachedProductList, AppError>> call() {
    return _repository.refreshProducts();
  }
}
