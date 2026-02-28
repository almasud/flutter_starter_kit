import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_dto.freezed.dart';
part 'product_dto.g.dart';

@freezed
abstract class ProductDto with _$ProductDto {
  const factory ProductDto({
    @Default(<ProductItemDto>[]) List<ProductItemDto> products,
    @Default(0) int total,
    @Default(0) int skip,
    @Default(0) int limit,
  }) = _ProductDto;

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);
}

@freezed
abstract class ProductItemDto with _$ProductItemDto {
  const factory ProductItemDto({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String description,
    @Default('') String category,
    @Default(0) double price,
    @Default(0) double discountPercentage,
    @Default(0) double rating,
    @Default(0) int stock,
    @Default('') String thumbnail,
    @Default(<String>[]) List<String> images,
  }) = _ProductItemDto;

  factory ProductItemDto.fromJson(Map<String, dynamic> json) =>
      _$ProductItemDtoFromJson(json);
}
