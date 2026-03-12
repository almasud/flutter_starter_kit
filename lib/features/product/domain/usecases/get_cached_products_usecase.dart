import 'package:flutter_starter_kit/features/product/domain/models/cached_product_list.dart';
import 'package:flutter_starter_kit/features/product/domain/repositories/product_repository.dart';

class GetCachedProductsUseCase {
  const GetCachedProductsUseCase(this._repository);

  final ProductRepository _repository;

  Future<CachedProductList?> call() {
    return _repository.getCachedProducts();
  }
}
