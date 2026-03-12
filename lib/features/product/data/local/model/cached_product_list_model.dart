import 'package:flutter_starter_kit/features/product/domain/models/product_list.dart';

class CachedProductListModel {
  const CachedProductListModel({required this.data, required this.fetchedAt});

  final ProductList data;
  final DateTime fetchedAt;
}
