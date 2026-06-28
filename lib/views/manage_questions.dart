import 'package:flutter/material.dart';
import '../model/quiz_category_model.dart';
import '../model/quiz_ques_model.dart';
import '../service/api_service.dart';
import 'add_question_via_api.dart';

class ManageQuestions extends StatefulWidget {
  const ManageQuestions({super.key, required this.category});
  final QuizCategory category;

  @override
  State<ManageQuestions> createState() => _ManageQuestionsState();
}

class _ManageQuestionsState extends State<ManageQuestions> {
  late Future<List<QuizQuestion>> _questionsFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _questionsFuture = ApiService.getQuestions(widget.category.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Questions: ${widget.category.name}")),
      body: FutureBuilder<List<QuizQuestion>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          final questions = snapshot.data ?? [];

          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final q = questions[index];
              return ListTile(
                title: Text(q.question),
                subtitle: Text("Mark: ${q.mark}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddQuestionViaApi(categoryId: widget.category.id, question: q)));
                        if (res == true) _refresh();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Delete Question?"),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await ApiService.deleteQuestion(q.id);
                          _refresh();
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddQuestionViaApi(categoryId: widget.category.id)));
          if (res == true) _refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
