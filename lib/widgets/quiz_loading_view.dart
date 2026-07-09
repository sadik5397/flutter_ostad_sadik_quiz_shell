import 'package:flutter/material.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:quiz_shell/widgets/quiz_loading_shimmer.dart';

class QuizLoadingView extends StatelessWidget {
  const QuizLoadingView({super.key, required this.isAiMode, required this.generated, required this.total, required this.displayName});

  final bool isAiMode;
  final int generated;
  final int total;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final double progress = total == 0 ? 0 : (generated / total).clamp(0.0, 1.0);

    return Column(
      children: <Widget>[
        if (isAiMode)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.auto_awesome, size: 18, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.craftingQuiz(displayName),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                    Text(
                      "$generated / $total",
                      style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: QuizLoadingShimmer(shownQuestions: generated, totalQuestions: total),
        ),
      ],
    );
  }
}
