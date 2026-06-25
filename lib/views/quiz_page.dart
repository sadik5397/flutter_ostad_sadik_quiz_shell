import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_shell/provider/quiz_provider.dart';
import 'package:quiz_shell/utils/numeric_serial_to_abc.dart';
import 'package:quiz_shell/widgets/answer_option.dart';
import 'package:quiz_shell/widgets/question_card.dart';
import 'package:quiz_shell/widgets/quiz_not_available.dart';
import 'package:quiz_shell/widgets/quiz_progress.dart';

import '../model/quiz_category_model.dart';
import '../widgets/quiz_result.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.category});

  final QuizCategory category;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  void initState() {
    super.initState();
    context.read<QuizProvider>().initiate(context, categoryId: widget.category.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("${widget.category.name} Quiz"),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xff2200a5)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Consumer<QuizProvider>(
              builder: (context, quizProvider, child) {
                return Text("Score: ${quizProvider.obtainedMark}", style: TextStyle(fontWeight: FontWeight.w500));
              },
            ),
          ),
        ],
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          return quizProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : quizProvider.questions.isEmpty
              ? QuizNotAvailable(categoryName: widget.category.name)
              : quizProvider.isQuizOver
              ? QuizResult(totalQuestions: quizProvider.questions.length, totalCorrect: quizProvider.totalCorrect, obtainedMark: quizProvider.obtainedMark)
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    spacing: 32,
                    children: [
                      QuizProgress(currentProgress: quizProvider.progress + 1, totalCount: quizProvider.questions.length),
                      QuestionCard(question: quizProvider.questions[quizProvider.progress].question),
                      Column(
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
                      Expanded(child: SizedBox()),
                      Column(
                        spacing: 16,
                        children: [
                          if (quizProvider.answerSubmitted)
                            Text(
                              quizProvider.selectedAnswerIndex == quizProvider.questions[quizProvider.progress].answerIndex ? "Correct Answer" : "Incorrect Answer",
                              style: TextStyle(
                                color: quizProvider.selectedAnswerIndex == quizProvider.questions[quizProvider.progress].answerIndex ? Colors.green.shade800 : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          SafeArea(
                            child: quizProvider.selectedAnswerIndex == null
                                ? SizedBox()
                                : quizProvider.answerSubmitted
                                ? ElevatedButton(
                                    onPressed: () => quizProvider.prepareNextQuestion(categoryName: widget.category.name),
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(Color(0xff2200a6)),
                                      fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, 56)),
                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12))),
                                    ),
                                    child: Text(
                                      "Next",
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : OutlinedButton(
                                    onPressed: quizProvider.submitAnswer,
                                    style: ButtonStyle(
                                      fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, 56)),
                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12))),
                                    ),
                                    child: Text("Submit", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
