import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.size = 24,
    this.strokeWidth = 2,
    this.centered = false,
  });

  final double size;
  final double strokeWidth;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final loader = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(strokeWidth: strokeWidth),
    );

    if (centered) {
      return Center(child: loader);
    }

    return loader;
  }
}
