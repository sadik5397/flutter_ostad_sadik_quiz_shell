import 'package:flutter/material.dart';
import 'package:quiz_shell/widgets/quiz_timer.dart';

class QuizProgress extends StatelessWidget {
  const QuizProgress({super.key, required this.currentProgress, required this.totalCount, this.onTimerEnd});

  final int currentProgress;
  final int totalCount;
  final VoidCallback? onTimerEnd;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      spacing: 16,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Questions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                Row(
                  children: [
                    Text(
                      currentProgress.toString(),
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
                    ),
                    Text("/$totalCount", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            QuizTimer(key: ValueKey(currentProgress), onTimerEnd: onTimerEnd),
          ],
        ),
        LinearProgressIndicator(value: currentProgress / totalCount, backgroundColor: colorScheme.surfaceContainerHigh),
      ],
    );
  }
}
