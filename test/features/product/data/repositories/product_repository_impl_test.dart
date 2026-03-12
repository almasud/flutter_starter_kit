import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/product/data/datasources/product_datasource.dart';
import 'package:flutter_starter_kit/features/product/data/local/datasources/product_local_datasource.dart';
import 'package:flutter_starter_kit/features/product/data/local/model/cached_product_list_model.dart';
import 'package:flutter_starter_kit/features/product/data/remote/model/dtos/product_dto.dart';
import 'package:flutter_starter_kit/features/product/data/repositories/product_repository_impl.dart';
import 'package:flutter_starter_kit/features/product/domain/models/cached_product_list.dart';
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

class _FakeProductLocalDatasource extends ProductLocalDatasource {
  CachedProductListModel? cached;
  ProductList? savedProducts;
  DateTime? savedAt;

  @override
  Future<void> clearProducts() async {
    cached = null;
  }

  @override
  Future<CachedProductListModel?> getCachedProducts() async => cached;

  @override
  Future<void> saveProducts(
    ProductList products, {
    required DateTime fetchedAt,
  }) async {
    savedProducts = products;
    savedAt = fetchedAt;
    cached = CachedProductListModel(data: products, fetchedAt: fetchedAt);
  }
}

void main() {
  group('ProductRepositoryImpl', () {
    test('returns mapped cached products when present', () async {
      final localDatasource = _FakeProductLocalDatasource()
        ..cached = CachedProductListModel(
          data: const ProductList(products: [], total: 0, skip: 0, limit: 0),
          fetchedAt: DateTime(2026, 3, 11),
        );
      final repository = ProductRepositoryImpl(
        _FakeProductDatasource(
          Success(ProductDto(products: const [], total: 0, skip: 0, limit: 0)),
        ),
        localDatasource,
      );

      final result = await repository.getCachedProducts();

      expect(result, isNotNull);
      expect(result?.fetchedAt, DateTime(2026, 3, 11));
    });

    test('refreshes products and stores them locally on success', () async {
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
      final localDatasource = _FakeProductLocalDatasource();
      final repository = ProductRepositoryImpl(datasource, localDatasource);

      final result = await repository.refreshProducts();

      expect(result, isA<Success<CachedProductList, AppError>>());

      final success = result as Success<CachedProductList, AppError>;
      expect(success.data.data.total, 100);
      expect(success.data.data.skip, 0);
      expect(success.data.data.limit, 30);
      expect(success.data.data.products.length, 1);
      expect(success.data.data.products.first.title, 'Phone');
      expect(localDatasource.savedProducts?.products.first.title, 'Phone');
      expect(localDatasource.savedAt, isNotNull);
    });

    test('forwards AppError on failure', () async {
      const appError = NetworkError(message: 'No internet');
      final datasource = _FakeProductDatasource(const Failure(appError));
      final repository = ProductRepositoryImpl(
        datasource,
        _FakeProductLocalDatasource(),
      );

      final result = await repository.refreshProducts();

      expect(result, isA<Failure<CachedProductList, AppError>>());

      final failure = result as Failure<CachedProductList, AppError>;
      expect(failure.error, appError);
    });
  });
}
