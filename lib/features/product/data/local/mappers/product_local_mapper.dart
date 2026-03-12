import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_starter_kit/core/data/local/app_database.dart';
import 'package:flutter_starter_kit/features/product/domain/models/product.dart';
import 'package:flutter_starter_kit/features/product/domain/models/product_list.dart';

extension ProductEntryMapper on ProductEntry {
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
      images: _decodeImages(imagesJson),
    );
  }
}

extension ProductListLocalMapper on ProductList {
  List<ProductEntriesCompanion> toCompanions() {
    return products
        .map(
          (product) => ProductEntriesCompanion(
            id: Value(product.id),
            title: Value(product.title),
            description: Value(product.description),
            category: Value(product.category),
            price: Value(product.price),
            discountPercentage: Value(product.discountPercentage),
            rating: Value(product.rating),
            stock: Value(product.stock),
            thumbnail: Value(product.thumbnail),
            imagesJson: Value(jsonEncode(product.images)),
          ),
        )
        .toList();
  }

  ProductCacheEntriesCompanion toMetaCompanion(DateTime fetchedAt) {
    return ProductCacheEntriesCompanion(
      cacheKey: const Value('products'),
      total: Value(total),
      skip: Value(skip),
      limit: Value(limit),
      fetchedAt: Value(fetchedAt),
    );
  }
}

List<String> _decodeImages(String value) {
  final decoded = jsonDecode(value);
  if (decoded is! List) {
    return const [];
  }

  return decoded.whereType<String>().toList();
}
