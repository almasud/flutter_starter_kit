import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/core/di/injection.dart';
import 'package:flutter_starter_kit/features/product/domain/entities/product.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_event.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_state.dart';

import '../../../../core/presentation/widgets/custom_app_bar.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductBloc>()..add(const ProductEvent.productsRequested()),
      child: Scaffold(
        appBar: AppToolBar(
          title: 'Products',
          showBackButton: false,
        ),
        body: SafeArea(
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              return switch (state.status) {
                ProductStatus.initial || ProductStatus.loading => const Center(
                  child: CircularProgressIndicator(),
                ),
                ProductStatus.success => RefreshIndicator(
                  onRefresh: () async {
                    context.read<ProductBloc>().add(const ProductEvent.productsRequested());
                  },
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    itemCount: state.data.products.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final product = state.data.products[index];
                      return _ProductCard(product: product);
                    },
                  ),
                ),
                ProductStatus.failure => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.message, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () {
                            context.read<ProductBloc>().add(const ProductEvent.productsRequested());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              };
            },
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.thumbnail,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 72,
                  height: 72,
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image_outlined),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text('Stock: ${product.stock}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
