import 'package:flutter/material.dart';

import '../views/quiz_categories.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.label, this.showSeeAll = true});

  final String label;
  final bool showSeeAll;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        if (showSeeAll)
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QuizCategories())),
            child: Text(
              "See All",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}
