import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/product/domain/models/cached_product_list.dart';
import 'package:flutter_starter_kit/features/product/domain/models/product.dart';
import 'package:flutter_starter_kit/features/product/domain/models/product_list.dart';
import 'package:flutter_starter_kit/features/product/domain/repositories/product_repository.dart';
import 'package:flutter_starter_kit/features/product/domain/usecases/get_cached_products_usecase.dart';
import 'package:flutter_starter_kit/features/product/domain/usecases/get_products_usecase.dart';
import 'package:flutter_starter_kit/features/product/domain/usecases/refresh_products_usecase.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_event.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeProductRepository extends ProductRepository {
  _FakeProductRepository(this._handler);

  final Future<ApiResult<ProductList, AppError>> Function({
    int skip,
    int limit,
    String query,
    String sortBy,
    String sortOrder,
  })
  _handler;

  @override
  Future<CachedProductList?> getCachedProducts() async => null;

  @override
  Future<ApiResult<ProductList, AppError>> getProducts({
    int skip = 0,
    int limit = 20,
    String query = '',
    String sortBy = 'title',
    String sortOrder = 'asc',
  }) {
    return _handler(
      skip: skip,
      limit: limit,
      query: query,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

  @override
  Future<ApiResult<CachedProductList, AppError>> refreshProducts() async {
    final result = await _handler(
      skip: 0,
      limit: 20,
      query: '',
      sortBy: 'title',
      sortOrder: 'asc',
    );

    return switch (result) {
      Success(:final data) => Success(
        CachedProductList(data: data, fetchedAt: DateTime(2026, 3, 12)),
      ),
      Failure(:final error) => Failure(error),
    };
  }
}

Product _product(int id) => Product(
  id: id,
  title: 'Product $id',
  description: 'Description $id',
  category: 'general',
  price: 10,
  discountPercentage: 0,
  rating: 4,
  stock: 10,
  thumbnail: 'thumb',
  images: const [],
);

void main() {
  group('ProductBloc', () {
    test('loads products with query and sort params', () async {
      late Map<String, dynamic> received;
      final repository = _FakeProductRepository(({
        int skip = 0,
        int limit = 20,
        String query = '',
        String sortBy = 'title',
        String sortOrder = 'asc',
      }) async {
        received = {
          'skip': skip,
          'limit': limit,
          'query': query,
          'sortBy': sortBy,
          'sortOrder': sortOrder,
        };
        return Success(
          ProductList(
            products: [_product(1), _product(2)],
            total: 5,
            skip: skip,
            limit: limit,
          ),
        );
      });
      final bloc = ProductBloc(
        GetCachedProductsUseCase(repository),
        GetProductsUseCase(repository),
        RefreshProductsUseCase(repository),
      );

      bloc.add(
        const ProductEvent.productsRequested(
          query: 'phone',
          sortBy: 'price',
          sortOrder: 'desc',
        ),
      );

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ProductState>().having(
            (s) => s.status,
            'status',
            ProductStatus.loading,
          ),
          isA<ProductState>()
              .having((s) => s.status, 'status', ProductStatus.success)
              .having((s) => s.data.products.length, 'count', 2)
              .having((s) => s.hasMore, 'hasMore', isTrue),
        ]),
      );

      expect(received['skip'], 0);
      expect(received['query'], 'phone');
      expect(received['sortBy'], 'price');
      expect(received['sortOrder'], 'desc');
    });

    test('load more appends products and keeps paging state', () async {
      var callCount = 0;
      final repository = _FakeProductRepository(({
        int skip = 0,
        int limit = 20,
        String query = '',
        String sortBy = 'title',
        String sortOrder = 'asc',
      }) async {
        callCount += 1;
        if (callCount == 1) {
          return Success(
            ProductList(
              products: [_product(1), _product(2)],
              total: 5,
              skip: 0,
              limit: limit,
            ),
          );
        }
        return Success(
          ProductList(
            products: [_product(3), _product(4)],
            total: 5,
            skip: skip,
            limit: limit,
          ),
        );
      });
      final bloc = ProductBloc(
        GetCachedProductsUseCase(repository),
        GetProductsUseCase(repository),
        RefreshProductsUseCase(repository),
      );

      bloc.add(const ProductEvent.productsRequested());
      await expectLater(
        bloc.stream,
        emitsThrough(
          isA<ProductState>().having(
            (s) => s.status,
            'status',
            ProductStatus.success,
          ),
        ),
      );

      bloc.add(const ProductEvent.productsRequested(loadMore: true));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ProductState>()
              .having((s) => s.isLoadingMore, 'isLoadingMore', isTrue)
              .having((s) => s.status, 'status', ProductStatus.success),
          isA<ProductState>()
              .having((s) => s.status, 'status', ProductStatus.success)
              .having((s) => s.data.products.length, 'count', 4)
              .having((s) => s.hasMore, 'hasMore', isTrue),
        ]),
      );
    });
  });
}
