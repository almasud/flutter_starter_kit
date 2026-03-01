import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_event.freezed.dart';

@freezed
abstract class ProductEvent with _$ProductEvent {
  const factory ProductEvent.productsRequested({
    String? query,
    String? sortBy,
    String? sortOrder,
    @Default(false) bool loadMore,
  }) = _ProductsRequested;
}
