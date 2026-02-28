import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_starter_kit/features/product/domain/entities/product.dart';

part 'product_list.freezed.dart';

@freezed
abstract class ProductList with _$ProductList {
  const factory ProductList({
    required List<Product> products,
    required int total,
    required int skip,
    required int limit,
  }) = _ProductList;
}
