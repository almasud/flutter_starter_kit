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
    );
  }

  Future<void> _onProductsStarted(Emitter<ProductState> emit) async {
    emit(ProductState.loading(previousData: state.data));

    final cached = await _getCachedProductsUseCase();
    if (cached != null) {
      emit(
        ProductState.success(
          cached.data,
          isRefreshing: true,
          lastUpdatedAt: cached.fetchedAt,
        ),
      );
    }

    final result = await _getProductsUseCase();
    _handleRefreshResult(result, emit, fallback: cached);
  }

  Future<void> _onProductsRefreshed(Emitter<ProductState> emit) async {
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

  void _handleRefreshResult(
    ApiResult<CachedProductList, AppError> result,
    Emitter<ProductState> emit, {
    CachedProductList? fallback,
  }) {
    switch (result) {
      case Success(:final data):
        emit(ProductState.success(data.data, lastUpdatedAt: data.fetchedAt));
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
            ),
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
}
