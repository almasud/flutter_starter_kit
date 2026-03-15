import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/product/domain/models/product_list.dart';
import 'package:flutter_starter_kit/features/product/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  const GetProductsUseCase(this._repository);

  final ProductRepository _repository;

  Future<ApiResult<ProductList, AppError>> call({
    int skip = 0,
    int limit = 20,
    String query = '',
    String sortBy = 'title',
    String sortOrder = 'asc',
  }) {
    return _repository.getProducts(
      skip: skip,
      limit: limit,
      query: query,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }
}
