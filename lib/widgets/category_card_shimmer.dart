import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A shimmer placeholder that mirrors [CategoryCard]'s exact dimensions
/// (150x110 rounded card with the same border treatment) so the row
/// stays visually stable while categories are still being fetched.
class CategoryCardShimmer extends StatelessWidget {
  const CategoryCardShimmer({super.key});

  static const double _width = 150;
  static const double _height = 110;
  static const double _radius = 12;
  static const double _borderWidth = 2;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Shimmer.fromColors(
        baseColor: colorScheme.surfaceContainerHighest,
        highlightColor: colorScheme.surfaceContainerHigh,
        period: const Duration(milliseconds: 1400),
        child: Container(
          width: _width,
          height: _height,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(_radius),
            border: Border.all(color: colorScheme.primary.withValues(alpha: .25), width: _borderWidth),
          ),
        ),
      ),
    );
  }
}
