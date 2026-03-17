import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductShimmerList extends StatelessWidget {
  const ProductShimmerList({
    super.key,
    this.itemCount = 5,
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 24),
  });

  final int itemCount;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: List.generate(itemCount, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index == itemCount - 1 ? 0 : 14),
            child: const _ShimmerProductCard(),
          );
        }),
      ),
    );
  }
}

class _ShimmerProductCard extends StatelessWidget {
  const _ShimmerProductCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _ShimmerBox(width: 92, height: 92, radius: 22),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ShimmerBox(width: 82, height: 22, radius: 999),
                      SizedBox(height: 14),
                      _ShimmerBox(width: double.infinity, height: 18, radius: 6),
                      SizedBox(height: 8),
                      _ShimmerBox(width: double.infinity, height: 14, radius: 6),
                      SizedBox(height: 6),
                      _ShimmerBox(width: 180, height: 14, radius: 6),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Row(
              children: [
                Expanded(child: _ShimmerBox(width: double.infinity, height: 44, radius: 16)),
                SizedBox(width: 10),
                Expanded(child: _ShimmerBox(width: double.infinity, height: 44, radius: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF1F2A29) : const Color(0xFFDCE6E1),
      highlightColor: isDark
          ? const Color(0xFF2A3736)
          : const Color(0xFFF7FAF8),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
