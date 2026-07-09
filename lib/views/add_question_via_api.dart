import 'package:flutter/material.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:quiz_shell/model/quiz_ques_model.dart';
import 'package:quiz_shell/service/api_service.dart';
import 'package:quiz_shell/utils/numeric_serial_to_abc.dart';
import 'package:quiz_shell/widgets/my_text_field.dart';

import '../widgets/option_field.dart';
import '../widgets/section_container.dart';

class AddQuestionViaApi extends StatefulWidget {
  const AddQuestionViaApi({super.key, required this.categoryId, this.question});

  final int categoryId;
  final QuizQuestion? question;

  @override
  State<AddQuestionViaApi> createState() => _AddQuestionViaApiState();
}

class _AddQuestionViaApiState extends State<AddQuestionViaApi> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController questionTitleController;
  late List<TextEditingController> optionControllers;
  late TextEditingController markController;
  int? currentAnswerIndex;

  @override
  void initState() {
    super.initState();
    questionTitleController = TextEditingController(text: widget.question?.question);
    markController = TextEditingController(text: (widget.question?.mark ?? 10).toString());
    currentAnswerIndex = widget.question?.answerIndex;

    if (widget.question != null) {
      optionControllers = widget.question!.options.map((e) => TextEditingController(text: e)).toList();
    } else {
      optionControllers = List.generate(2, (_) => TextEditingController());
    }
  }

  void addOption() {
    final l10n = AppLocalizations.of(context)!;
    if (optionControllers.length < 10) {
      setState(() => optionControllers.add(TextEditingController()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.maxOptionsAllowed)));
    }
  }

  void removeOption(int index) {
    if (optionControllers.length > 2) {
      setState(() {
        optionControllers.removeAt(index);
        if (currentAnswerIndex == index) {
          currentAnswerIndex = null;
        } else if (currentAnswerIndex != null && currentAnswerIndex! > index) {
          currentAnswerIndex = currentAnswerIndex! - 1;
        }
      });
    }
  }

  Future<void> submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (currentAnswerIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.pleaseSelectCorrectAnswer), backgroundColor: Colors.orange));
      return;
    }

    Map<String, dynamic> data = {
      "question": questionTitleController.text.trim(),
      "options": optionControllers.map((e) => e.text.trim()).toList(),
      "answerIndex": currentAnswerIndex,
      "mark": int.tryParse(markController.text) ?? 10,
    };

    try {
      if (widget.question == null) {
        await ApiService.createQuestion(widget.categoryId, data);
      } else {
        await ApiService.updateQuestion(widget.question!.id, data);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.success), backgroundColor: Colors.green));
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${l10n.error}: $e"), backgroundColor: Colors.red));
    }
  }

  @override
  void dispose() {
    questionTitleController.dispose();
    for (var controller in optionControllers) {
      controller.dispose();
    }
    markController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(backgroundColor: colorScheme.surface, title: Text(widget.question == null ? l10n.addQuestion : l10n.editQuestion), elevation: 0),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SectionContainer(
              title: l10n.theQuestion,
              child: MyTextField(controller: questionTitleController, label: l10n.enterQuestionTitle, validator: (value) => (value == null || value.isEmpty) ? l10n.enterQuestion : null),
            ),

            SectionContainer(
              title: l10n.answerOptions,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: RadioGroup<int?>(
                      groupValue: currentAnswerIndex,
                      onChanged: (value) => setState(() => currentAnswerIndex = value),
                      child: Column(
                        spacing: 12,
                        children: List.generate(optionControllers.length, (index) {
                          return OptionField(
                            controller: optionControllers[index],
                            label: "${l10n.option} ${numericSerialToAbc(index).toUpperCase()}",
                            index: index,
                            onRemove: optionControllers.length > 2 ? () => removeOption(index) : null,
                          );
                        }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 42),
                    child: OutlinedButton.icon(
                      onPressed: addOption,
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addMoreOptions),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                        side: BorderSide(color: colorScheme.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SectionContainer(
              title: l10n.misc,
              child: MyTextField(
                controller: markController,
                label: l10n.markForThisQuestion,
                showNumberKeyboardOnly: true,
                validator: (value) => (value == null || value.isEmpty) ? l10n.enterMark : null,
              ),
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(widget.question == null ? l10n.submitQuestion : l10n.updateQuestion, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
