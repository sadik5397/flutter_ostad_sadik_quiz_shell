import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/quiz_category_model.dart';
import '../model/quiz_ques_model.dart';

class ApiService {
  static const String baseUrl = "https://sadiks-quiz-apihub.lovable.app/api/v1";
  static const String aiUrl = "https://openrouter.ai/api/v1/chat/completions";
  static const String apiKey = "";

  // --- Categories ---
  static Future<List<QuizCategory>> getCategories() async {
    final response = await http.get(Uri.parse("$baseUrl/categories"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List).map((e) => QuizCategory.fromJson(e)).toList();
    }
    throw Exception("Failed to load categories");
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

  // --- AI Response ---
  static Future<String?> getResponseFromAI(String msg) async {
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
      throw Exception("AI service error: ${response.statusCode}");
    } else {
      final result = jsonDecode(response.body);
      return result["choices"]?[0]?["message"]?["content"]?.toString();
    }
  }
}
