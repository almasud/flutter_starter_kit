import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/core/di/injection.dart';
import 'package:flutter_starter_kit/core/presentation/widgets/app_snack_bar.dart';
import 'package:flutter_starter_kit/features/product/domain/models/product.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_event.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_state.dart';
import 'package:flutter_starter_kit/features/product/presentation/widgets/product_shimmer_list.dart';

import '../../../../core/presentation/widgets/custom_app_bar.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ProductBloc>()..add(const ProductEvent.productsStarted()),
      child: Scaffold(
        appBar: AppToolBar(title: 'Products', showBackButton: false),
        body: SafeArea(
          child: BlocListener<ProductBloc, ProductState>(
            listenWhen: (previous, current) =>
                previous.message != current.message,
            listener: (context, state) {
              if (state.message.isNotEmpty) {
                AppSnackBar.showError(context, state.message);
              }
            },
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                final hasData = state.data.products.isNotEmpty;

                if (!hasData &&
                    (state.status == ProductStatus.initial ||
                        state.status == ProductStatus.loading)) {
                  return const ProductShimmerList();
                }

                if (!hasData && state.status == ProductStatus.failure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.message, textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: () {
                              context.read<ProductBloc>().add(
                                const ProductEvent.productsStarted(),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    if (state.isRefreshing) const LinearProgressIndicator(),
                    if (state.isStale || state.lastUpdatedAt != null)
                      _CacheStatusBanner(
                        isStale: state.isStale,
                        lastUpdatedAt: state.lastUpdatedAt,
                      ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<ProductBloc>().add(
                            const ProductEvent.productsRefreshed(),
                          );
                        },
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(12),
                          itemCount: state.data.products.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final product = state.data.products[index];
                            return _ProductCard(product: product);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CacheStatusBanner extends StatelessWidget {
  const _CacheStatusBanner({
    required this.isStale,
    required this.lastUpdatedAt,
  });

  final bool isStale;
  final DateTime? lastUpdatedAt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lastUpdatedLabel = lastUpdatedAt == null
        ? 'Unknown'
        : _formatDateTime(lastUpdatedAt!);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: isStale
          ? theme.colorScheme.errorContainer
          : theme.colorScheme.surfaceContainerHighest,
      child: Text(
        isStale
            ? 'Showing cached products. Last updated $lastUpdatedLabel.'
            : 'Last updated $lastUpdatedLabel.',
        style: theme.textTheme.bodySmall?.copyWith(
          color: isStale
              ? theme.colorScheme.onErrorContainer
              : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime value) {
    final local = value.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.year}-$month-$day $hour:$minute';
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
