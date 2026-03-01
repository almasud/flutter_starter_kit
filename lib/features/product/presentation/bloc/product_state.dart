import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_starter_kit/features/product/domain/models/product_list.dart';

part 'product_state.freezed.dart';

enum ProductStatus { initial, loading, success, failure }

@freezed
abstract class ProductState with _$ProductState {
  const factory ProductState({
    @Default(ProductStatus.initial) ProductStatus status,
    @Default(ProductList(products: [], total: 0, skip: 0, limit: 0))
    ProductList data,
    @Default(20) int pageSize,
    @Default('') String query,
    @Default('title') String sortBy,
    @Default('asc') String sortOrder,
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
    @Default('') String message,
  }) = _ProductState;

  factory ProductState.initial() => const ProductState();
}
