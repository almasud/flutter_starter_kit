import 'package:dio/dio.dart';
import 'package:flutter_starter_kit/core/data/remote/safe_api_call.dart';
import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/features/product/data/remote/model/dtos/product_dto.dart';

import '../../../../core/domain/models/app_error.dart';

abstract class ProductDatasource {
  Future<ApiResult<ProductDto, AppError>> getProducts({
    int skip = 0,
    int limit = 20,
    String query = '',
    String sortBy = 'title',
    String sortOrder = 'asc',
  });
}

class ProductDatasourceImpl extends ProductDatasource {
  final Dio _dio;

  ProductDatasourceImpl(this._dio);

  @override
  Future<ApiResult<ProductDto, AppError>> getProducts({
    int skip = 0,
    int limit = 20,
    String query = '',
    String sortBy = 'title',
    String sortOrder = 'asc',
  }) => safeApiCall(
    () => _dio.get(
      query.trim().isEmpty ? '/products' : '/products/search',
      queryParameters: {
        'skip': skip,
        'limit': limit,
        if (query.trim().isNotEmpty) 'q': query.trim(),
        'sortBy': sortBy,
        'order': sortOrder,
      },
    ),
    (json) => ProductDto.fromJson(Map<String, dynamic>.from(json as Map)),
  );
}
