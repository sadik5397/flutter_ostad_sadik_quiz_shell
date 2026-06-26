import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  static Box? hiveStorage;

  static Future<void> initialize() async {
    await Hive.initFlutter();
    hiveStorage = await Hive.openBox("QuizShell");
  }

  static Box get box {
    if (hiveStorage == null) throw Exception("Database not found");
    return hiveStorage!;
  }

  //read all questions
  static List get myQuestions => box.get("myQuestions") ?? [];

  //save All questions
  static Future<void> saveAllQuestions(List questions) async {
    await box.put("myQuestions", questions);
  }

  //create new question
  static Future<void> addQuestion(Map<String, dynamic> question) async {
    List existingQuestions = myQuestions;
    existingQuestions.add(question);
    await saveAllQuestions(existingQuestions);
  }

  //update an existing question
  static Future<void> updateQuestion(Map<String, dynamic> question) async {
    List existingQuestions = myQuestions;
    int index = existingQuestions.indexWhere((ques) => ques['id'] == question['id']);
    existingQuestions[index] = question;
    await saveAllQuestions(existingQuestions);
  }

  //delete a question
  static Future<void> deleteQuestion(Map<String, dynamic> question) async {
    List existingQuestions = myQuestions;
    existingQuestions.removeWhere((ques) => ques['id'] == question['id']);
    await saveAllQuestions(existingQuestions);
  }
}
