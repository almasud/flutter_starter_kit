import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/product/domain/models/cached_product_list.dart';
import 'package:flutter_starter_kit/features/product/domain/usecases/get_cached_products_usecase.dart';
import 'package:flutter_starter_kit/features/product/domain/usecases/get_products_usecase.dart';
import 'package:flutter_starter_kit/features/product/domain/usecases/refresh_products_usecase.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_event.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(
    this._getCachedProductsUseCase,
    this._getProductsUseCase,
    this._refreshProductsUseCase,
  ) : super(ProductState.initial()) {
    on<ProductEvent>(_onEvent);
  }

  final GetCachedProductsUseCase _getCachedProductsUseCase;
  final GetProductsUseCase _getProductsUseCase;
  final RefreshProductsUseCase _refreshProductsUseCase;

  Future<void> _onEvent(ProductEvent event, Emitter<ProductState> emit) async {
    await event.map(
      productsStarted: (_) => _onProductsStarted(emit),
      productsRefreshed: (_) => _onProductsRefreshed(emit),
      productsRequested: (event) => _onProductsRequested(
        emit,
        query: event.query,
        sortBy: event.sortBy,
        sortOrder: event.sortOrder,
        loadMore: event.loadMore,
      ),
    );
  }

  Future<void> _onProductsStarted(Emitter<ProductState> emit) async {
    emit(
      ProductState.loading(
        previousData: state.data.products.isEmpty ? null : state.data,
      ),
    );

    final cached = await _getCachedProductsUseCase();
    if (cached != null) {
      emit(
        ProductState.success(
          cached.data,
          isRefreshing: true,
          lastUpdatedAt: cached.fetchedAt,
        ).copyWith(hasMore: cached.data.products.length < cached.data.total),
      );
    }

    final result = await _refreshProductsUseCase();
    _handleRefreshResult(result, emit, fallback: cached);
  }

  Future<void> _onProductsRefreshed(Emitter<ProductState> emit) async {
    if (!_isDefaultListing(
      query: state.query,
      sortBy: state.sortBy,
      sortOrder: state.sortOrder,
    )) {
      await _onProductsRequested(
        emit,
        query: state.query,
        sortBy: state.sortBy,
        sortOrder: state.sortOrder,
      );
      return;
    }

    if (state.data.products.isNotEmpty) {
      emit(
        state.copyWith(
          status: ProductStatus.success,
          isRefreshing: true,
          message: '',
        ),
      );
    } else {
      emit(
        ProductState.loading(
          previousData: state.data,
          lastUpdatedAt: state.lastUpdatedAt,
          isStale: state.isStale,
        ),
      );
    }

    final result = await _refreshProductsUseCase();
    _handleRefreshResult(result, emit);
  }

  Future<void> _onProductsRequested(
    Emitter<ProductState> emit, {
    String? query,
    String? sortBy,
    String? sortOrder,
    bool loadMore = false,
  }) async {
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
          isRefreshing: false,
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
          isRefreshing: false,
          isStale: false,
          lastUpdatedAt: _isDefaultListing(
            query: activeQuery,
            sortBy: activeSortBy,
            sortOrder: activeSortOrder,
          )
              ? state.lastUpdatedAt
              : null,
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
        final isDefaultListing = _isDefaultListing(
          query: activeQuery,
          sortBy: activeSortBy,
          sortOrder: activeSortOrder,
        );

        emit(
          state.copyWith(
            status: ProductStatus.success,
            data: mergedData,
            query: activeQuery,
            sortBy: activeSortBy,
            sortOrder: activeSortOrder,
            hasMore: mergedProducts.length < data.total,
            isLoadingMore: false,
            isRefreshing: false,
            isStale: false,
            lastUpdatedAt: isDefaultListing ? state.lastUpdatedAt : null,
            message: '',
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            status: ProductStatus.failure,
            message: _mapError(error),
            isLoadingMore: false,
            isRefreshing: false,
          ),
        );
    }
  }

  void _handleRefreshResult(
    ApiResult<CachedProductList, AppError> result,
    Emitter<ProductState> emit, {
    CachedProductList? fallback,
  }) {
    switch (result) {
      case Success(:final data):
        emit(
          ProductState.success(
            data.data,
            lastUpdatedAt: data.fetchedAt,
          ).copyWith(hasMore: data.data.products.length < data.data.total),
        );
      case Failure(:final error):
        final message = _mapError(error);
        final visibleData = fallback?.data ?? state.data;
        final lastUpdatedAt = fallback?.fetchedAt ?? state.lastUpdatedAt;

        if (visibleData.products.isNotEmpty) {
          emit(
            ProductState.success(
              visibleData,
              isStale: true,
              lastUpdatedAt: lastUpdatedAt,
              message: message,
            ).copyWith(hasMore: visibleData.products.length < visibleData.total),
          );
          return;
        }

        emit(
          ProductState.failure(
            message: message,
            previousData: state.data,
            lastUpdatedAt: lastUpdatedAt,
          ),
        );
    }
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

  bool _isDefaultListing({
    required String query,
    required String sortBy,
    required String sortOrder,
  }) {
    return query.isEmpty && sortBy == 'title' && sortOrder == 'asc';
  }
}
