import 'package:dio/dio.dart';
import 'package:flutter_starter_kit/core/data/remote/safe_api_call.dart';
import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/features/product/data/remote/model/dtos/product_dto.dart';

import '../../../../core/domain/models/app_error.dart';

abstract class ProductDatasource {
  Future<ApiResult<ProductDto, AppError>> getProducts();
}

class ProductDatasourceImpl extends ProductDatasource {
  final Dio _dio;

  ProductDatasourceImpl(this._dio);

  @override
  Future<ApiResult<ProductDto, AppError>> getProducts() =>
      safeApiCall(
          () => _dio.get('/products'),
          (json) => ProductDto.fromJson(
            Map<String, dynamic>.from(json as Map),
          ),
      );
}
