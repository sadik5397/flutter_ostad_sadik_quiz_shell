import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({super.key, required this.question});

  final String question;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.tertiary, width: 1),
      ),
      child: Text(
        question,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: colorScheme.onTertiaryContainer,
        ),
      ),
    );
  }
}
