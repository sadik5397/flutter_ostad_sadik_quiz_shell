import 'package:flutter/material.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';

class QuizNotAvailable extends StatelessWidget {
  const QuizNotAvailable({super.key, required this.categoryName});

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          Icon(Icons.warning_amber_outlined, size: 110, color: colorScheme.error),
          Text("${categoryName} ${l10n.quizNotAvailable}"),
        ],
      ),
    );
  }
}
