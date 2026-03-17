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
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) =>
          getIt<ProductBloc>()..add(const ProductEvent.productsStarted()),
      child: Scaffold(
        appBar: AppToolBar(
          title: ProductStrings.products,
          subtitle: 'Search, sort, cache, and refresh in one flow',
          showBackButton: false,
          actions: [
            IconButton.filledTonal(
              tooltip: ProductStrings.logout,
              onPressed: _onLogout,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.16),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ),
        body: SafeArea(
          top: false,
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
                if (_searchController.text != state.query) {
                  _searchController.value = TextEditingValue(
                    text: state.query,
                    selection: TextSelection.collapsed(
                      offset: state.query.length,
                    ),
                  );
                }

                final hasData = state.data.products.isNotEmpty;

                return RefreshIndicator(
                  onRefresh: () async {
                    _refreshCurrentView(context, state);
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                    children: [
                      _ProductSummaryCard(state: state),
                      const SizedBox(height: 14),
                      _FilterPanel(
                        searchController: _searchController,
                        state: state,
                        onSearchChanged: (value, currentState) =>
                            _onSearchChanged(context, value, currentState),
                        onSearchSubmitted: (value, currentState) =>
                            _onSearchSubmitted(context, value, currentState),
                      ),
                      if (state.isRefreshing) ...[
                        const SizedBox(height: 12),
                        const ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(999)),
                          child: LinearProgressIndicator(minHeight: 5),
                        ),
                      ],
                      if (_shouldShowCacheBanner(state)) ...[
                        const SizedBox(height: 12),
                        _CacheStatusBanner(
                          isStale: state.isStale,
                          lastUpdatedAt: state.lastUpdatedAt,
                        ),
                      ],
                      const SizedBox(height: 16),
                      if (!hasData &&
                          (state.status == ProductStatus.initial ||
                              state.status == ProductStatus.loading))
                        const ProductShimmerList(
                          itemCount: 4,
                          padding: EdgeInsets.zero,
                        )
                      else if (!hasData && state.status == ProductStatus.failure)
                        _FailureState(
                          message: state.message,
                          onRetry: () {
                            context.read<ProductBloc>().add(
                              const ProductEvent.productsStarted(),
                            );
                          },
                        )
                      else ...[
                        ...state.data.products.map(
                          (product) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _ProductCard(product: product),
                          ),
                        ),
                        _LoadMoreSection(state: state),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
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

class _ProductSummaryCard extends StatelessWidget {
  const _ProductSummaryCard({required this.state});

  final ProductState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.84),
            colorScheme.tertiaryContainer.withValues(alpha: 0.84),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Catalog overview',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              state.query.isEmpty
                  ? 'Browse the default catalog, refresh cached data, or change the sort order.'
                  : 'Showing results for "${state.query}" sorted by ${state.sortBy} (${state.sortOrder.toUpperCase()}).',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _InfoTile(
                  label: 'Visible',
                  value: '${state.data.products.length}',
                ),
                _InfoTile(
                  label: 'Total',
                  value: '${state.data.total}',
                ),
                _InfoTile(
                  label: 'Sort',
                  value: state.sortBy.toUpperCase(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Find products', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Search by keyword and refine the result set without leaving the page.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: ProductStrings.searchByKeyword,
                prefixIcon: const Icon(Icons.search_rounded),
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
            const SizedBox(height: 18),
            Row(
              children: [
                Text(ProductStrings.sort, style: theme.textTheme.labelLarge),
                const Spacer(),
                FilledButton.tonalIcon(
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
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _sortLabels.entries.map((entry) {
                final isSelected = state.sortBy == entry.key;
                return ChoiceChip(
                  label: Text(entry.value),
                  selected: isSelected,
                  avatar: isSelected
                      ? Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: colorScheme.primary,
                        )
                      : null,
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
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadMoreSection extends StatelessWidget {
  const _LoadMoreSection({required this.state});

  final ProductState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (!state.hasMore) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            'You have reached the end of the current result set.',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Center(
      child: FilledButton.tonalIcon(
        onPressed: () {
          context.read<ProductBloc>().add(
            const ProductEvent.productsRequested(loadMore: true),
          );
        },
        icon: const Icon(Icons.expand_more_rounded),
        label: const Text(ProductStrings.loadMore),
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
    final colorScheme = theme.colorScheme;
    final lastUpdatedLabel = lastUpdatedAt == null
        ? 'Unknown'
        : _formatDateTime(lastUpdatedAt!);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isStale
            ? colorScheme.errorContainer
            : colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            isStale ? Icons.history_toggle_off_rounded : Icons.schedule_rounded,
            color: isStale
                ? colorScheme.onErrorContainer
                : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isStale
                  ? 'Showing cached products. Last updated $lastUpdatedLabel.'
                  : 'Last updated $lastUpdatedLabel.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isStale
                    ? colorScheme.onErrorContainer
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
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

class _FailureState extends StatelessWidget {
  const _FailureState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(
                    Icons.wifi_off_rounded,
                    size: 34,
                    color: colorScheme.onErrorContainer,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Unable to load products', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text(ProductStrings.retry),
                ),
              ],
            ),
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
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProductThumbnail(url: product.thumbnail),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          product.category.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.7,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        product.title,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _MetricPill(
                    icon: Icons.attach_money_rounded,
                    label: 'Price',
                    value: '\$${product.price.toStringAsFixed(2)}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricPill(
                    icon: Icons.star_rounded,
                    label: 'Rating',
                    value: product.rating.toStringAsFixed(1),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricPill(
                    icon: Icons.inventory_2_outlined,
                    label: 'Stock',
                    value: '${product.stock}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductThumbnail extends StatelessWidget {
  const _ProductThumbnail({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        width: 96,
        height: 96,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: colorScheme.surfaceContainerHighest,
            alignment: Alignment.center,
            child: Icon(
              Icons.broken_image_outlined,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(height: 10),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.titleSmall,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints: const BoxConstraints(minWidth: 96),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}
