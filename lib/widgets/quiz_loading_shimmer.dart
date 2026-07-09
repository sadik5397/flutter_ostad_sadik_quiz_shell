import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quiz_shell/theme/theme_padding.dart';
import 'package:quiz_shell/widgets/shimmer_block.dart';
import 'package:shimmer/shimmer.dart';

class QuizLoadingShimmer extends StatefulWidget {
  const QuizLoadingShimmer({super.key, this.shownQuestions = 0, this.totalQuestions = 5});

  final int shownQuestions;
  final int totalQuestions;

  @override
  State<QuizLoadingShimmer> createState() => _QuizLoadingShimmerState();
}

class _QuizLoadingShimmerState extends State<QuizLoadingShimmer> {
  late final List<double> heights;

  @override
  void initState() {
    super.initState();
    final random = Random();
    heights = [100 + random.nextDouble() * 60, for (int i = 0; i < 12; i++) 20 + random.nextDouble() * 100, 48 + random.nextDouble() * 20];
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color base = colorScheme.surfaceContainerHighest;
    final Color highlight = colorScheme.surfaceContainerHigh;
    return SingleChildScrollView(
      padding: ThemePadding.all,
      physics: const NeverScrollableScrollPhysics(),
      child: Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        period: const Duration(milliseconds: 1400),
        child: Column(
          spacing: ThemePadding.value,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ShimmerBlock(height: heights[0], radius: 12),
            for (int i = 0; i < 12; i++) ...<Widget>[ShimmerBlock(height: heights[i + 1], radius: 12)],
            ShimmerBlock(height: heights.last, radius: 12),
          ],
        ),
      ),
    );
  }
}
