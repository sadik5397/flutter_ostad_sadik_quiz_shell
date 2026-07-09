import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_shell/provider/category_provider.dart';

import '../l10n/app_localizations.dart';
import '../widgets/ai_quiz_card.dart';
import '../widgets/category_card.dart';

class QuizCategories extends StatelessWidget {
  const QuizCategories({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(backgroundColor: colorScheme.surface, title: Text(l10n.quizCategories)),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          return RefreshIndicator(
            onRefresh: () => categoryProvider.loadQuizCategories(context),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16) + const EdgeInsets.only(bottom: 16),
              children: [
                const AiQuizCard(),
                ...categoryProvider.allCategories.map((cat) => CategoryCard(category: cat)),
              ],
            ),
          );
        },
      ),
    );
  }
}
