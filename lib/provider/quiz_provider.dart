import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/quiz_ques_model.dart';
import '../service/database_service.dart';

class QuizProvider with ChangeNotifier {
  int? selectedAnswerIndex;
  bool answerCorrect = false;
  bool answerSubmitted = false;
  int obtainedMark = 0;
  int totalCorrect = 0;
  int progress = 0;
  List<QuizQuestion> questions = [];
  bool isLoading = false;
  bool isQuizOver = false;

  void setAnswer(int currentIndex) {
    if (selectedAnswerIndex == currentIndex) {
      selectedAnswerIndex = null;
    } else {
      selectedAnswerIndex = currentIndex;
    }
    notifyListeners();
  }

  Future<void> submitAnswer() async {
    if (selectedAnswerIndex == null) return;
    answerCorrect = (selectedAnswerIndex == questions[progress].answerIndex);
    answerSubmitted = true;
    if (answerCorrect) {
      totalCorrect++;
      obtainedMark = obtainedMark + questions[progress].mark;
      SharedPreferences pref = await SharedPreferences.getInstance();
      int currentTotalScore = pref.getInt('score') ?? 0;
      pref.setInt('score', currentTotalScore + questions[progress].mark);
    }
    notifyListeners();
  }

  Future<void> prepareNextQuestion({required String categoryName}) async {
    if (progress < questions.length - 1) {
      progress++;
      answerCorrect = false;
      answerSubmitted = false;
      selectedAnswerIndex = null;
      notifyListeners();
    } else {
      isQuizOver = true;
      notifyListeners();
      await DatabaseService().saveQuizSession(gainedScore: obtainedMark, totalAttempt: questions.length, totalCorrect: totalCorrect, category: categoryName);
    }
  }

  Future<void> initiate(BuildContext context, {required int categoryId}) async {
    // Reset all states
    selectedAnswerIndex = null;
    answerCorrect = false;
    answerSubmitted = false;
    obtainedMark = 0;
    totalCorrect = 0;
    progress = 0;
    questions = [];
    isQuizOver = false;
    isLoading = true;
    notifyListeners();
    await loadAllQuestionsOfThisCategory(context, categoryId: categoryId);
  }

  Future<void> loadAllQuestionsOfThisCategory(BuildContext context, {required int categoryId}) async {
    List<QuizQuestion> allQuestionsOfThisCategory = [];
    try {
      String url = "https://sadiks-quiz-apihub.lovable.app/api/v1/categories/$categoryId/questions";
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        List data = result["data"];
        allQuestionsOfThisCategory = data.map((item) => QuizQuestion.fromJson(item)).toList();
      } else {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to load questions from server")));
      }
    } catch (e) {
      debugPrint("Error loading questions: $e");
    }

    questions = (List<QuizQuestion>.from(allQuestionsOfThisCategory)..shuffle()).take(5).toList();
    isLoading = false;
    notifyListeners();
  }
}
