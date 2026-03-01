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
    @Default('') String message,
  }) = _ProductState;

  factory ProductState.initial() => const ProductState();

  factory ProductState.loading({ProductList? previousData}) => ProductState(
    status: ProductStatus.loading,
    data:
        previousData ??
        const ProductList(products: [], total: 0, skip: 0, limit: 0),
  );

  factory ProductState.success(ProductList data) =>
      ProductState(status: ProductStatus.success, data: data);

  factory ProductState.failure({
    required String message,
    ProductList? previousData,
  }) => ProductState(
    status: ProductStatus.failure,
    data:
        previousData ??
        const ProductList(products: [], total: 0, skip: 0, limit: 0),
    message: message,
  );
}
