import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/product/domain/usecases/get_products_usecase.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_event.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(this._getProductsUseCase) : super(ProductState.initial()) {
    on<ProductEvent>(_onEvent);
  }

  final GetProductsUseCase _getProductsUseCase;

  Future<void> _onEvent(ProductEvent event, Emitter<ProductState> emit) async {
    await event.when(
      productsRequested: (query, sortBy, sortOrder, loadMore) async {
        final activeQuery = (query ?? state.query).trim();
        final activeSortBy = (sortBy ?? state.sortBy).trim();
        final activeSortOrder = (sortOrder ?? state.sortOrder).trim();
        final canLoadMore = loadMore && state.hasMore && !state.isLoadingMore;

        if (loadMore && !canLoadMore) return;

        if (canLoadMore) {
          emit(
            state.copyWith(
              status: ProductStatus.success,
              isLoadingMore: true,
              message: '',
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: ProductStatus.loading,
              query: activeQuery,
              sortBy: activeSortBy,
              sortOrder: activeSortOrder,
              isLoadingMore: false,
              message: '',
            ),
          );
        }

        final nextSkip = canLoadMore ? state.data.products.length : 0;
        final result = await _getProductsUseCase(
          skip: nextSkip,
          limit: state.pageSize,
          query: activeQuery,
          sortBy: activeSortBy,
          sortOrder: activeSortOrder,
        );

        switch (result) {
          case Success(:final data):
            final mergedProducts = canLoadMore
                ? [...state.data.products, ...data.products]
                : data.products;
            final mergedData = data.copyWith(products: mergedProducts);

            emit(
              state.copyWith(
                status: ProductStatus.success,
                data: mergedData,
                query: activeQuery,
                sortBy: activeSortBy,
                sortOrder: activeSortOrder,
                hasMore: mergedProducts.length < data.total,
                isLoadingMore: false,
                message: '',
              ),
            );
          case Failure(:final error):
            emit(
              state.copyWith(
                status: ProductStatus.failure,
                message: _mapError(error),
                isLoadingMore: false,
              ),
            );
        }
      },
    );
  }

  String _mapError(AppError error) {
    return switch (error) {
      NetworkError(:final message) => message ?? 'Network error',
      UnauthorizedError(:final message) => message ?? 'Unauthorized',
      ValidationError(:final message) => message ?? 'Validation error',
      ServerError(:final message) => message ?? 'Server error',
      UnknownError(:final message) => message ?? 'Unknown error',
    };
  }
}
