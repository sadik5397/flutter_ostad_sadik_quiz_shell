import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:quiz_shell/widgets/question_preview.dart';
import 'package:quiz_shell/widgets/quiz_loading_shimmer.dart';

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
    final l10n = AppLocalizations.of(context)!;
    String url = "https://sadiks-quiz-apihub.lovable.app/api/v1/categories/1/questions";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      List data = result["data"];
      setState(() => allQuestions = data.map((item) => QuizQuestion.fromJson(item)).toList());
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.failedToLoadQuestions)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(backgroundColor: colorScheme.surface, title: Text(l10n.locallyAddedQuestions)),
      body: allQuestions.isEmpty
          ? const Center(child: QuizLoadingShimmer())
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
