import 'package:flutter/material.dart';

class QuizTimer extends StatefulWidget {
  const QuizTimer({super.key});

  @override
  State<QuizTimer> createState() => _QuizTimerState();
}

class _QuizTimerState extends State<QuizTimer> {
  int totalSeconds = 60;
  late int remainingSecond;

  @override
  void initState() {
    super.initState();
    remainingSecond = totalSeconds;
    startTimer();
  }

  void startTimer() async {
    await Future.delayed(Duration(seconds: 1));
    if (!mounted) return;
    setState(() => remainingSecond--);
    if (remainingSecond > 0) startTimer();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: CircularProgressIndicator(
            value: remainingSecond / totalSeconds,
            backgroundColor: colorScheme.outlineVariant,
            color: remainingSecond < 10 ? colorScheme.error : colorScheme.primary,
          ),
        ),
        Text(
          "00:${remainingSecond < 10 ? '0' : ''}$remainingSecond",
          style: TextStyle(
            color: remainingSecond < 10 ? colorScheme.error : colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
