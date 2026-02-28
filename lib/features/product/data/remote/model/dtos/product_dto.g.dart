// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) => _ProductDto(
  products:
      (json['products'] as List<dynamic>?)
          ?.map((e) => ProductItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ProductItemDto>[],
  total: (json['total'] as num?)?.toInt() ?? 0,
  skip: (json['skip'] as num?)?.toInt() ?? 0,
  limit: (json['limit'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ProductDtoToJson(_ProductDto instance) =>
    <String, dynamic>{
      'products': instance.products,
      'total': instance.total,
      'skip': instance.skip,
      'limit': instance.limit,
    };

_ProductItemDto _$ProductItemDtoFromJson(Map<String, dynamic> json) =>
    _ProductItemDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      thumbnail: json['thumbnail'] as String? ?? '',
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$ProductItemDtoToJson(_ProductItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'price': instance.price,
      'discountPercentage': instance.discountPercentage,
      'rating': instance.rating,
      'stock': instance.stock,
      'thumbnail': instance.thumbnail,
      'images': instance.images,
    };
