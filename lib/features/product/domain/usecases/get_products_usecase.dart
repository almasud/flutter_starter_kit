import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/product/domain/entities/product_list.dart';
import 'package:flutter_starter_kit/features/product/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  const GetProductsUseCase(this._repository);

  final ProductRepository _repository;

  Future<ApiResult<ProductList, AppError>> call() {
    return _repository.getProducts();
  }
}
