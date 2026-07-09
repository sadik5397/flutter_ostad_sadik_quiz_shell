import 'package:flutter/material.dart';

class AnswerOption extends StatelessWidget {
  const AnswerOption({super.key, required this.option, required this.serial, this.isSelected = false, this.onTap, this.showCorrectAnswer = false});

  final String option;
  final String serial;
  final bool isSelected;
  final bool showCorrectAnswer;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: showCorrectAnswer
              ? Colors.green.withValues(alpha: 0.1)
              : isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: showCorrectAnswer
                ? Colors.green
                : isSelected
                ? colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          spacing: 16,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.primary.withValues(alpha: .15),
              child: Text(
                serial,
                style: TextStyle(
                  color: showCorrectAnswer
                      ? Colors.green
                      : isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  color: showCorrectAnswer
                      ? Colors.green
                      : isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
