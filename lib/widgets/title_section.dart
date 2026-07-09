import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../views/quiz_categories.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.label, this.showSeeAll = true});

  final String label;
  final bool showSeeAll;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        ),
        if (showSeeAll)
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizCategories())),
            child: Text(
              l10n.seeAll,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colorScheme.primary),
            ),
          ),
      ],
    );
  }
}
