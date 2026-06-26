import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/quiz_category_model.dart';

class CategoryProvider with ChangeNotifier {
  List<QuizCategory> allCategories = [];

  Future<void> initiate(BuildContext context) async {
    await loadQuizCategories(context);
  }

  Future<void> loadQuizCategories(BuildContext context) async {
    String url = "https://sadiks-quiz-apihub.lovable.app/api/v1/categories";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      List data = result["data"];
      allCategories = data.map((item) => QuizCategory.fromJson(item)).toList();
      notifyListeners();
    } else {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to load categories")));
    }
  }
}
