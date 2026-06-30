import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/quiz_category_model.dart';
import '../model/quiz_ques_model.dart';

class ApiService {
  static const String baseUrl = "https://sadiks-quiz-apihub.lovable.app/api/v1";
  static const String aiUrl = "https://openrouter.ai/api/v1/chat/completions";
  static const String apiKey = "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";

  // --- Categories ---
  static Future<List<QuizCategory>> getCategories() async {
    final response = await http.get(Uri.parse("$baseUrl/categories"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List).map((e) => QuizCategory.fromJson(e)).toList();
    }
    throw Exception("Failed to load categories");
  }

  static Future<void> createCategory(String name, String description) async {
    final response = await http.post(Uri.parse("$baseUrl/categories"), headers: {"Content-Type": "application/json"}, body: jsonEncode({"name": name, "description": description}));
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to create category");
    }
  }

  static Future<void> updateCategory(int id, String name, String description) async {
    final response = await http.put(Uri.parse("$baseUrl/categories/$id"), headers: {"Content-Type": "application/json"}, body: jsonEncode({"name": name, "description": description}));
    if (response.statusCode != 200) {
      throw Exception("Failed to update category");
    }
  }

  static Future<void> deleteCategory(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/categories/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete category");
    }
  }

  // --- Questions ---
  static Future<List<QuizQuestion>> getQuestions(int categoryId) async {
    final response = await http.get(Uri.parse("$baseUrl/categories/$categoryId/questions"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List).map((e) => QuizQuestion.fromJson(e)).toList();
    }
    throw Exception("Failed to load questions");
  }

  static Future<void> createQuestion(int categoryId, Map<String, dynamic> questionData) async {
    final response = await http.post(Uri.parse("$baseUrl/categories/$categoryId/questions"), headers: {"Content-Type": "application/json"}, body: jsonEncode(questionData));
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to create question");
    }
  }

  static Future<void> updateQuestion(int questionId, Map<String, dynamic> questionData) async {
    final response = await http.put(Uri.parse("$baseUrl/questions/$questionId"), headers: {"Content-Type": "application/json"}, body: jsonEncode(questionData));
    if (response.statusCode != 200) {
      throw Exception("Failed to update question");
    }
  }

  static Future<void> deleteQuestion(int questionId) async {
    final response = await http.delete(Uri.parse("$baseUrl/questions/$questionId"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete question");
    }
  }

  // --- AI Response ---
  static Future<String>? getResponseFromAI(String msg) async {
    final response = await http.post(
      Uri.parse(aiUrl),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer $apiKey"},
      body: jsonEncode({
        "model": "google/gemini-2.5-flash-lite",
        "max_tokens": 200,
        "messages": [
          {"role": "user", "content": msg},
        ],
      }),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update question");
    } else {
      final result = jsonDecode(response.body);
      return result["choices"][0]["message"]["content"].toString();
    }
  }
}
