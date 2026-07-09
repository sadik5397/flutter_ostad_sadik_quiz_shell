import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:quiz_shell/provider/quiz_provider.dart';
import 'package:quiz_shell/utils/numeric_serial_to_abc.dart';
import 'package:quiz_shell/widgets/answer_option.dart';
import 'package:quiz_shell/widgets/question_card.dart';
import 'package:quiz_shell/widgets/quiz_not_available.dart';
import 'package:quiz_shell/widgets/quiz_progress.dart';

import '../model/quiz_category_model.dart';
import '../widgets/quiz_loading_view.dart';
import '../widgets/quiz_result.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, this.category, this.aiTopic});

  final QuizCategory? category;
  final String? aiTopic;

  bool get isAiMode => aiTopic != null;

  String get displayName => aiTopic ?? category?.name ?? 'Quiz';

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  void initState() {
    super.initState();
    final QuizProvider provider = context.read<QuizProvider>();
    if (widget.isAiMode) {
      provider.initiateAiQuiz(context, topic: widget.aiTopic!);
    } else {
      provider.initiate(context, categoryId: widget.category!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final String title = widget.isAiMode ? "AI • ${widget.displayName}" : "${widget.displayName} ${l10n.quiz}";
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text(title),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.primary),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Consumer<QuizProvider>(
              builder: (context, quizProvider, child) {
                return Text("${l10n.score}: ${quizProvider.obtainedMark}", style: const TextStyle(fontWeight: FontWeight.w500));
              },
            ),
          ),
        ],
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          return quizProvider.isLoading
              ? QuizLoadingView(isAiMode: widget.isAiMode, generated: quizProvider.aiQuestionsGenerated, total: quizProvider.aiQuestionsTotal, displayName: widget.displayName)
              : quizProvider.questions.isEmpty
              ? QuizNotAvailable(categoryName: widget.displayName)
              : quizProvider.isQuizOver
              ? QuizResult(totalQuestions: quizProvider.questions.length, totalCorrect: quizProvider.totalCorrect, obtainedMark: quizProvider.obtainedMark)
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    spacing: 32,
                    children: [
                      QuizProgress(
                        currentProgress: quizProvider.progress + 1,
                        totalCount: quizProvider.questions.length,
                        onTimerEnd: () => quizProvider.prepareNextQuestion(categoryName: widget.displayName),
                      ),
                      QuestionCard(question: quizProvider.questions[quizProvider.progress].question),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            spacing: 12,
                            children: List.generate(
                              quizProvider.questions[quizProvider.progress].options.length,
                              (currentIndex) => AnswerOption(
                                option: quizProvider.questions[quizProvider.progress].options[currentIndex],
                                serial: numericSerialToAbc(currentIndex),
                                isSelected: quizProvider.selectedAnswerIndex == currentIndex,
                                onTap: quizProvider.answerSubmitted ? null : () => quizProvider.setAnswer(currentIndex),
                                showCorrectAnswer: quizProvider.questions[quizProvider.progress].answerIndex == currentIndex && quizProvider.answerSubmitted,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        spacing: 16,
                        children: [
                          if (quizProvider.answerSubmitted)
                            Text(
                              quizProvider.selectedAnswerIndex == quizProvider.questions[quizProvider.progress].answerIndex ? l10n.correctAnswer : l10n.incorrectAnswer,
                              style: TextStyle(
                                color: quizProvider.selectedAnswerIndex == quizProvider.questions[quizProvider.progress].answerIndex ? Colors.green : colorScheme.error,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          SafeArea(
                            child: quizProvider.selectedAnswerIndex == null
                                ? const SizedBox()
                                : quizProvider.answerSubmitted
                                ? ElevatedButton(
                                    onPressed: () => quizProvider.prepareNextQuestion(categoryName: widget.displayName),
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
                                      fixedSize: const WidgetStatePropertyAll(Size(double.maxFinite, 56)),
                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                    ),
                                    child: Text(
                                      l10n.next,
                                      style: TextStyle(color: colorScheme.onPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : OutlinedButton(
                                    onPressed: quizProvider.submitAnswer,
                                    style: ButtonStyle(
                                      fixedSize: const WidgetStatePropertyAll(Size(double.maxFinite, 56)),
                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                    ),
                                    child: Text(l10n.submit, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
