import 'package:flutter/material.dart';

import '../model/quiz_ques_model.dart';

class QuestionPreview extends StatelessWidget {
  const QuestionPreview({super.key, required this.question, required this.index});

  final QuizQuestion question;
  final int index;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 7,
      color: colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Q${index + 1}: ${question.question}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(question.options.length, (optIndex) {
              bool isCorrect = optIndex == question.answerIndex;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  "${String.fromCharCode(65 + optIndex)}) ${question.options[optIndex]}",
                  style: TextStyle(
                    color: isCorrect ? Colors.green : colorScheme.onSurfaceVariant,
                    fontWeight: isCorrect ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }),
            Divider(color: colorScheme.outlineVariant),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Mark: ${question.mark}",
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
