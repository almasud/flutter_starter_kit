import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter_kit/features/product/data/mappers/product_mapper.dart';
import 'package:flutter_starter_kit/features/product/data/remote/model/dtos/product_dto.dart';

void main() {
  group('ProductDtoMapper.toDomain', () {
    test('maps dto fields to ProductList domain model', () {
      final dto = ProductDto(
        products: [
          ProductItemDto(
            id: 1,
            title: 'Phone',
            description: 'A smartphone',
            category: 'electronics',
            price: 999.99,
            discountPercentage: 10.5,
            rating: 4.8,
            stock: 12,
            thumbnail: 'thumb.png',
            images: const ['a.png', 'b.png'],
          ),
        ],
        total: 100,
        skip: 0,
        limit: 30,
      );

      final domain = dto.toDomain();

      expect(domain.total, 100);
      expect(domain.skip, 0);
      expect(domain.limit, 30);
      expect(domain.products.length, 1);
      expect(domain.products.first.id, 1);
      expect(domain.products.first.title, 'Phone');
      expect(domain.products.first.description, 'A smartphone');
      expect(domain.products.first.category, 'electronics');
      expect(domain.products.first.price, 999.99);
      expect(domain.products.first.discountPercentage, 10.5);
      expect(domain.products.first.rating, 4.8);
      expect(domain.products.first.stock, 12);
      expect(domain.products.first.thumbnail, 'thumb.png');
      expect(domain.products.first.images, ['a.png', 'b.png']);
    });

    test('uses safe defaults from dto defaults', () {
      final dto = ProductDto(products: [ProductItemDto()]);

      final domain = dto.toDomain();
      final product = domain.products.first;

      expect(domain.total, 0);
      expect(domain.skip, 0);
      expect(domain.limit, 0);
      expect(product.id, 0);
      expect(product.title, '');
      expect(product.description, '');
      expect(product.category, '');
      expect(product.price, 0);
      expect(product.discountPercentage, 0);
      expect(product.rating, 0);
      expect(product.stock, 0);
      expect(product.thumbnail, '');
      expect(product.images, isEmpty);
    });
  });
}
