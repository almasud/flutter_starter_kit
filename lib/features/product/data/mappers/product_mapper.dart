import 'package:flutter_starter_kit/features/product/data/remote/model/dtos/product_dto.dart';
import 'package:flutter_starter_kit/features/product/domain/models/product.dart';
import 'package:flutter_starter_kit/features/product/domain/models/product_list.dart';

extension ProductDtoMapper on ProductDto {
  ProductList toDomain() {
    return ProductList(
      products: products.map((product) => product.toDomain()).toList(),
      total: total,
      skip: skip,
      limit: limit,
    );
  }
}

extension ProductItemDtoMapper on ProductItemDto {
  Product toDomain() {
    return Product(
      id: id,
      title: title,
      description: description,
      category: category,
      price: price,
      discountPercentage: discountPercentage,
      rating: rating,
      stock: stock,
      thumbnail: thumbnail,
      images: images,
    );
  }
}
