import 'package:flutter/material.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:quiz_shell/theme/theme_padding.dart';
import 'package:quiz_shell/widgets/question_preview.dart';
import 'package:quiz_shell/widgets/quiz_loading_shimmer.dart';

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

  Future<void> _handleRefresh() async {
    _refresh();
    await _questionsFuture;
  }

  Future<void> _editQuestion(QuizQuestion q) async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddQuestionViaApi(categoryId: widget.category.id, question: q),
      ),
    );
    if (res == true) _refresh();
  }

  Future<void> _deleteQuestion(QuizQuestion q) async {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteQuestion),
        content: Text(l10n.deleteQuestionWarning),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: colorScheme.error, foregroundColor: colorScheme.onError),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await ApiService.deleteQuestion(q.id);
        _refresh();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: colorScheme.error));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: FutureBuilder<List<QuizQuestion>>(
          future: _questionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const QuizLoadingShimmer();
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                    const SizedBox(height: 16),
                    Text("${l10n.error}: ${snapshot.error}"),
                    TextButton(onPressed: _refresh, child: Text(l10n.retry)),
                  ],
                ),
              );
            }
            final questions = snapshot.data ?? [];

            if (questions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.quiz_outlined, size: 80, color: colorScheme.outline),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noQuestionsInCategory,
                      style: TextStyle(fontSize: 18, color: colorScheme.outline, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.tapToAddFirstQuestion),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: ThemePadding.horizontal + ThemePadding.bottom * 12,
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final q = questions[index];
                return QuestionPreview(question: q, index: index, onEdit: () => _editQuestion(q), onDelete: () => _deleteQuestion(q));
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddQuestionViaApi(categoryId: widget.category.id)));
          if (res == true) _refresh();
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.addQuestion),
      ),
    );
  }
}
