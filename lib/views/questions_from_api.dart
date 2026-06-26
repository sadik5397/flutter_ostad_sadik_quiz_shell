import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_shell/widgets/question_preview.dart';

import '../model/quiz_ques_model.dart';

class QuestionsFromApi extends StatefulWidget {
  const QuestionsFromApi({super.key});

  @override
  State<QuestionsFromApi> createState() => _QuestionsFromApiState();
}

class _QuestionsFromApiState extends State<QuestionsFromApi> {
  List<QuizQuestion> allQuestions = [];

  @override
  void initState() {
    super.initState();
    loadAllQuestions();
  }

  Future<void> loadAllQuestions() async {
    String url = "https://sadiks-quiz-apihub.lovable.app/api/v1/categories/1/questions";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      List data = result["data"];
      setState(() => allQuestions = data.map((item) => QuizQuestion.fromJson(item)).toList());
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to load questions")));
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: const Text("Locally Added Questions"),
      ),
      body: allQuestions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadAllQuestions,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: allQuestions.length,
                itemBuilder: (context, index) => QuestionPreview(question: allQuestions[index], index: index),
              ),
            ),
    );
  }
}
