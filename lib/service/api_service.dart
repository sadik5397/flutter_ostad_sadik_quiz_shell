import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/quiz_category_model.dart';
import '../model/quiz_ques_model.dart';

class ApiService {
  static const String baseUrl = "https://sadiks-quiz-apihub.lovable.app/api/v1";

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
    final response = await http.post(
      Uri.parse("$baseUrl/categories"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "description": description}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to create category");
    }
  }

  static Future<void> updateCategory(int id, String name, String description) async {
    final response = await http.put(
      Uri.parse("$baseUrl/categories/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "description": description}),
    );
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
    final response = await http.post(
      Uri.parse("$baseUrl/categories/$categoryId/questions"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(questionData),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to create question");
    }
  }

  static Future<void> updateQuestion(int questionId, Map<String, dynamic> questionData) async {
    final response = await http.put(
      Uri.parse("$baseUrl/questions/$questionId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(questionData),
    );
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
}
