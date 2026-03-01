import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/product/data/datasources/product_datasource.dart';
import 'package:flutter_starter_kit/features/product/data/mappers/product_mapper.dart';
import 'package:flutter_starter_kit/features/product/domain/models/product_list.dart';
import 'package:flutter_starter_kit/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl extends ProductRepository {
  ProductRepositoryImpl(this._datasource);

  final ProductDatasource _datasource;

  @override
  Future<ApiResult<ProductList, AppError>> getProducts() async {
    final result = await _datasource.getProducts();
    return result.map((dto) => dto.toDomain());
  }
}
