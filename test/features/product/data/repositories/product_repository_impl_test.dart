import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/product/data/datasources/product_datasource.dart';
import 'package:flutter_starter_kit/features/product/data/remote/model/dtos/product_dto.dart';
import 'package:flutter_starter_kit/features/product/data/repositories/product_repository_impl.dart';
import 'package:flutter_starter_kit/features/product/domain/models/product_list.dart';

class _FakeProductDatasource extends ProductDatasource {
  _FakeProductDatasource(this._result);

  final ApiResult<ProductDto, AppError> _result;

  @override
  Future<ApiResult<ProductDto, AppError>> getProducts({
    int skip = 0,
    int limit = 20,
    String query = '',
    String sortBy = 'title',
    String sortOrder = 'asc',
  }) async => _result;
}

void main() {
  group('ProductRepositoryImpl.getProducts', () {
    test('returns mapped ProductList on success', () async {
      final datasource = _FakeProductDatasource(
        Success(
          ProductDto(
            products: [
              ProductItemDto(
                id: 1,
                title: 'Phone',
                description: 'A smartphone',
                category: 'electronics',
                price: 999.99,
                discountPercentage: 10.5,
                rating: 4.8,
                stock: 12,
                thumbnail: 'thumb.png',
                images: const ['a.png', 'b.png'],
              ),
            ],
            total: 100,
            skip: 0,
            limit: 30,
          ),
        ),
      );
      final repository = ProductRepositoryImpl(datasource);

      final result = await repository.getProducts();

      expect(result, isA<Success<ProductList, AppError>>());

      final success = result as Success<ProductList, AppError>;
      expect(success.data.total, 100);
      expect(success.data.skip, 0);
      expect(success.data.limit, 30);
      expect(success.data.products.length, 1);
      expect(success.data.products.first.title, 'Phone');
    });

    test('forwards AppError on failure', () async {
      const appError = NetworkError(message: 'No internet');
      final datasource = _FakeProductDatasource(const Failure(appError));
      final repository = ProductRepositoryImpl(datasource);

      final result = await repository.getProducts();

      expect(result, isA<Failure<ProductList, AppError>>());

      final failure = result as Failure<ProductList, AppError>;
      expect(failure.error, appError);
    });
  });
}
