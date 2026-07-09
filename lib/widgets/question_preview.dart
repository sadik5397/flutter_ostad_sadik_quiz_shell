import 'package:flutter/material.dart';

import '../model/quiz_ques_model.dart';

class QuestionPreview extends StatelessWidget {
  const QuestionPreview({super.key, required this.question, required this.index, this.onEdit, this.onDelete});

  final QuizQuestion question;
  final int index;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      color: colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    "Q${index + 1}",
                    style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    question.question,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.onSurface),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...List.generate(question.options.length, (optIndex) {
              bool isCorrect = optIndex == question.answerIndex;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: isCorrect ? Colors.green.withValues(alpha: 0.15) : colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        String.fromCharCode(65 + optIndex),
                        style: TextStyle(color: isCorrect ? Colors.green.shade700 : colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        question.options[optIndex],
                        style: TextStyle(color: isCorrect ? Colors.green.shade700 : colorScheme.onSurfaceVariant, fontWeight: isCorrect ? FontWeight.w600 : FontWeight.normal),
                      ),
                    ),
                    if (isCorrect) const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  ],
                ),
              );
            }),
            Divider(color: colorScheme.outlineVariant, height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onEdit != null)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    icon: Icon(Icons.edit_outlined, color: colorScheme.primary, size: 20),
                    onPressed: onEdit,
                  ),
                if (onDelete != null)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    icon: Icon(Icons.delete_outline, color: colorScheme.error, size: 20),
                    onPressed: onDelete,
                  ),
                Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    "Mark: ${question.mark}",
                    style: TextStyle(color: colorScheme.onSecondaryContainer, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
