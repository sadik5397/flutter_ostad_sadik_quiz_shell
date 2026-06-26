import 'package:flutter/material.dart';

import '../model/quiz_category_model.dart';
import '../views/quiz_page.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category});

  final QuizCategory category;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QuizPage(category: category))),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(color: colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(12), border: Border.all(color: colorScheme.primary.withValues(alpha: .25), width: 2)),
          width: 180,
          height: 120,
          child: Stack(
            children: [
              Positioned(
                bottom: -62,
                right: -16,
                child: Text(
                  category.name[0],
                  style: TextStyle(
                    fontSize: 136,
                    fontWeight: FontWeight.w100,
                    color: colorScheme.onSecondaryContainer.withValues(alpha: .1),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    category.name,
                    style: TextStyle(color: colorScheme.onSecondaryContainer, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
