import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/core/di/injection.dart';
import 'package:flutter_starter_kit/core/presentation/router/app_router.dart';
import 'package:flutter_starter_kit/core/presentation/router/auth_guard.dart';
import 'package:flutter_starter_kit/core/presentation/widgets/app_snack_bar.dart';
import 'package:flutter_starter_kit/features/product/domain/models/product.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_event.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_state.dart';
import 'package:flutter_starter_kit/features/product/presentation/constants/product_strings.dart';
import 'package:flutter_starter_kit/features/product/presentation/widgets/product_shimmer_list.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/widgets/custom_app_bar.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late final TextEditingController _searchController;
  Timer? _searchDebounce;
  static const _searchDebounceDuration = Duration(milliseconds: 350);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ProductBloc>()..add(const ProductEvent.productsStarted()),
      child: Scaffold(
        appBar: AppToolBar(
          title: ProductStrings.products,
          showBackButton: false,
          actions: [
            IconButton(
              tooltip: ProductStrings.logout,
              onPressed: _onLogout,
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
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

                return Column(
                  children: [
                    _FilterBar(
                      searchController: _searchController,
                      state: state,
                      onSearchChanged: (value, currentState) =>
                          _onSearchChanged(context, value, currentState),
                      onSearchSubmitted: (value, currentState) =>
                          _onSearchSubmitted(context, value, currentState),
                    ),
                    if (state.isRefreshing) const LinearProgressIndicator(),
                    if (_shouldShowCacheBanner(state))
                      _CacheStatusBanner(
                        isStale: state.isStale,
                        lastUpdatedAt: state.lastUpdatedAt,
                      ),
                    Expanded(child: _buildBody(context, state, hasData)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductState state, bool hasData) {
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
                child: const Text(ProductStrings.retry),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _refreshCurrentView(context, state);
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        itemCount: state.data.products.length + 1,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index >= state.data.products.length) {
            return _LoadMoreSection(state: state);
          }

          final product = state.data.products[index];
          return _ProductCard(product: product);
        },
      ),
    );
  }

  void _onSearchChanged(
    BuildContext blocContext,
    String rawValue,
    ProductState state,
  ) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(_searchDebounceDuration, () {
      if (!mounted) return;
      final normalized = _normalizeQuery(rawValue);
      blocContext.read<ProductBloc>().add(
        ProductEvent.productsRequested(
          query: normalized,
          sortBy: state.sortBy,
          sortOrder: state.sortOrder,
        ),
      );
    });
  }

  void _onSearchSubmitted(
    BuildContext blocContext,
    String rawValue,
    ProductState state,
  ) {
    _searchDebounce?.cancel();
    final normalized = _normalizeQuery(rawValue);
    blocContext.read<ProductBloc>().add(
      ProductEvent.productsRequested(
        query: normalized,
        sortBy: state.sortBy,
        sortOrder: state.sortOrder,
      ),
    );
  }

  String _normalizeQuery(String value) {
    return value
        .trim()
        .split(RegExp(r'\s+'))
        .where((token) => token.isNotEmpty)
        .join(' ');
  }

  bool _shouldShowCacheBanner(ProductState state) {
    return state.query.isEmpty &&
        state.sortBy == 'title' &&
        state.sortOrder == 'asc' &&
        (state.isStale || state.lastUpdatedAt != null);
  }

  void _refreshCurrentView(BuildContext context, ProductState state) {
    if (state.query.isEmpty &&
        state.sortBy == 'title' &&
        state.sortOrder == 'asc') {
      context.read<ProductBloc>().add(const ProductEvent.productsRefreshed());
      return;
    }

    context.read<ProductBloc>().add(
      ProductEvent.productsRequested(
        query: state.query,
        sortBy: state.sortBy,
        sortOrder: state.sortOrder,
      ),
    );
  }

  Future<void> _onLogout() async {
    await getIt<AuthGuard>().clearSession();
    if (!mounted) return;
    context.go(AppRouter.loginPath);
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.searchController,
    required this.state,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
  });

  final TextEditingController searchController;
  final ProductState state;
  final void Function(String value, ProductState state) onSearchChanged;
  final void Function(String value, ProductState state) onSearchSubmitted;

  static const _sortLabels = {
    'title': ProductStrings.sortTitle,
    'price': ProductStrings.sortPrice,
    'rating': ProductStrings.sortRating,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: ProductStrings.searchByKeyword,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: searchController,
                builder: (context, value, _) {
                  if (value.text.isEmpty) return const SizedBox.shrink();
                  return IconButton(
                    tooltip: ProductStrings.clearSearch,
                    onPressed: () {
                      searchController.clear();
                      onSearchSubmitted('', state);
                    },
                    icon: const Icon(Icons.close_rounded),
                  );
                },
              ),
            ),
            onChanged: (value) => onSearchChanged(value, state),
            onSubmitted: (value) => onSearchSubmitted(value, state),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                ProductStrings.sort,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const Spacer(),
              Tooltip(
                message: state.sortOrder == 'asc'
                    ? ProductStrings.ascendingOrder
                    : ProductStrings.descendingOrder,
                child: FilledButton.tonalIcon(
                  onPressed: () {
                    context.read<ProductBloc>().add(
                      ProductEvent.productsRequested(
                        query: state.query,
                        sortBy: state.sortBy,
                        sortOrder: state.sortOrder == 'asc' ? 'desc' : 'asc',
                      ),
                    );
                  },
                  icon: const Icon(Icons.swap_vert_rounded),
                  label: Text(
                    state.sortOrder == 'asc'
                        ? ProductStrings.asc
                        : ProductStrings.desc,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._sortLabels.entries.map((entry) {
                return ChoiceChip(
                  label: Text(entry.value),
                  selected: state.sortBy == entry.key,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: const StadiumBorder(),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                  onSelected: (selected) {
                    if (!selected) return;
                    context.read<ProductBloc>().add(
                      ProductEvent.productsRequested(
                        query: state.query,
                        sortBy: entry.key,
                        sortOrder: state.sortOrder,
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoadMoreSection extends StatelessWidget {
  const _LoadMoreSection({required this.state});

  final ProductState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (!state.hasMore) {
      return const SizedBox.shrink();
    }

    return Center(
      child: FilledButton.tonal(
        onPressed: () {
          context.read<ProductBloc>().add(
            const ProductEvent.productsRequested(loadMore: true),
          );
        },
        child: const Text(ProductStrings.loadMore),
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
                      const SizedBox(width: 10),
                      Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: Colors.amber.shade700,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: theme.textTheme.bodySmall,
                      ),
                      const Spacer(),
                      Text('${ProductStrings.stockPrefix}${product.stock}'),
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
