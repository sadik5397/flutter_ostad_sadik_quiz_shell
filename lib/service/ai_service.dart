import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../model/quiz_ques_model.dart';

class AiService {
  static const String _aiUrl = "https://openrouter.ai/api/v1/chat/completions";
  static const String _apiKey = "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";
  static const String _model = "google/gemini-2.5-flash-lite";

  /// Generate [count] multiple-choice questions on [topic] using OpenRouter.
  /// Returns a list of [QuizQuestion]; throws on any failure.
  /// [onQuestionGenerated] is called after each successful fetch (1..count)
  /// so the caller can update a progress UI.
  static Future<List<QuizQuestion>> generateQuizQuestions({required String topic, int count = 5, void Function(int generated, int total)? onQuestionGenerated}) async {
    final List<QuizQuestion> questions = [];
    final Random rng = Random();
    // Sequential calls — keeps each request within the strict schema.
    for (int i = 0; i < count; i++) {
      final QuizQuestion q = await _fetchOneQuestion(topic: topic, questionIndex: i + 1, totalQuestions: count, rng: rng);
      questions.add(q);
      onQuestionGenerated?.call(questions.length, count);
    }
    return questions;
  }

  static Future<QuizQuestion> _fetchOneQuestion({required String topic, required int questionIndex, required int totalQuestions, required Random rng}) async {
    final Map<String, dynamic> body = {
      "model": _model,
      "messages": [
        {"role": "system", "content": "You are a quiz generator. Return only valid JSON matching the provided schema."},
        {
          "role": "user",
          "content":
              "Generate question $questionIndex of $totalQuestions ($topic). "
              "Make it different in style and difficulty from previous questions. "
              "Exactly 4 options, only one correct. Keep the question concise.",
        },
      ],
      "response_format": {
        "type": "json_schema",
        "json_schema": {
          "name": "quiz_question",
          "strict": true,
          "schema": {
            "type": "object",
            "additionalProperties": false,
            "properties": {
              "id": {"type": "integer", "description": "A random 6-digit integer."},
              "question": {"type": "string", "description": "A clear multiple-choice question."},
              "options": {
                "type": "array",
                "description": "Exactly 4 answer options.",
                "items": {"type": "string"},
                "minItems": 4,
                "maxItems": 4,
              },
              "answerIndex": {"type": "integer", "description": "Index of the correct answer (0-3).", "minimum": 0, "maximum": 3},
              "mark": {"type": "integer", "description": "Marks awarded based on question complexity (10-20).", "minimum": 10, "maximum": 20},
            },
            "required": ["id", "question", "options", "answerIndex", "mark"],
          },
        },
      },
    };

    final http.Response response = await http.post(Uri.parse(_aiUrl), headers: {"Content-Type": "application/json", "Authorization": "Bearer $_apiKey"}, body: jsonEncode(body));

    if (response.statusCode != 200) {
      throw Exception("AI request failed (${response.statusCode}): ${response.body}");
    }

    final Map<String, dynamic> result = jsonDecode(response.body);
    final String content = result["choices"][0]["message"]["content"].toString();
    final Map<String, dynamic> questionJson = jsonDecode(content);
    // Guarantee a 6-digit id even if the model returns a small number.
    if ((questionJson["id"] as int? ?? 0) < 100000) {
      questionJson["id"] = 100000 + rng.nextInt(900000);
    }
    return QuizQuestion.fromJson(questionJson);
  }
}
