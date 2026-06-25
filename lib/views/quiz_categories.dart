import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_shell/provider/category_provider.dart';

import '../widgets/category_card.dart';

class QuizCategories extends StatelessWidget {
  const QuizCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz Categories")),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          return RefreshIndicator(
            onRefresh: () => categoryProvider.loadQuizCategories(context),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16) + const EdgeInsets.only(bottom: 16),
              children: categoryProvider.allCategories.map((cat) => CategoryCard(category: cat)).toList(),
            ),
          );
        },
      ),
    );
  }
}
