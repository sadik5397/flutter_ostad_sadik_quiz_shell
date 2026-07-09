import 'package:flutter/material.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:quiz_shell/utils/numeric_serial_to_abc.dart';
import 'package:quiz_shell/widgets/my_text_field.dart';

import '../service/hive_database.dart';
import '../widgets/option_field.dart';
import '../widgets/section_container.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({super.key});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController questionTitleController = TextEditingController();
  final List<TextEditingController> optionControllers = List.generate(2, (_) => TextEditingController());
  final TextEditingController markController = TextEditingController(text: "10");
  int? currentAnswerIndex;

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

  Future<void> addQuestion() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (currentAnswerIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.pleaseSelectCorrectAnswerLong), backgroundColor: Colors.orange));
      return;
    }

    Map<String, dynamic> questionAsJson = {
      "id": DateTime.now().millisecondsSinceEpoch,
      "question": questionTitleController.text.trim(),
      "options": optionControllers.map((e) => e.text.trim()).toList(),
      "answerIndex": currentAnswerIndex,
      "mark": int.tryParse(markController.text) ?? 10,
    };

    try {
      await HiveDatabase.addQuestion(questionAsJson);
      resetForm();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.questionSavedSuccessfully), backgroundColor: Colors.green));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.errorSavingQuestion(e.toString())), backgroundColor: Colors.red));
    }
  }

  void resetForm() {
    questionTitleController.clear();
    for (var controller in optionControllers) {
      controller.dispose();
    }
    optionControllers.clear();
    optionControllers.addAll(List.generate(2, (_) => TextEditingController()));
    markController.text = "10";
    setState(() => currentAnswerIndex = null);
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
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text(l10n.addNewQuestion),
        elevation: 0,
        actions: [IconButton(onPressed: resetForm, icon: const Icon(Icons.refresh), tooltip: l10n.resetForm)],
      ),
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
                onPressed: addQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(l10n.submitQuestion, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
