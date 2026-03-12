import 'package:flutter_starter_kit/features/product/domain/models/product_list.dart';

class CachedProductList {
  const CachedProductList({required this.data, required this.fetchedAt});

  final ProductList data;
  final DateTime fetchedAt;
}
