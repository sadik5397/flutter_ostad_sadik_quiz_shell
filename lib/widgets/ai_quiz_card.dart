import 'package:flutter/material.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/quiz_page.dart';
import 'subscription_guard.dart';

const String _kAiRecentsKey = 'ai_quiz_recents';
const int _kAiRecentsMax = 12;

class AiQuizCard extends StatelessWidget {
  const AiQuizCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          if (!SubscriptionGuard.canStart(context)) return;
          _showTopicBottomSheet(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.tertiary], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: .35), width: 2),
          ),
          width: 150,
          height: 110,
          child: Stack(
            children: [
              Positioned(
                bottom: -50,
                right: -10,
                child: Text(
                  "AI",
                  style: TextStyle(fontSize: 120, fontWeight: FontWeight.w100, color: Colors.white.withValues(alpha: .12), letterSpacing: -4),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .22),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: .35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, size: 12, color: Colors.white),
                      const SizedBox(width: 4),
                      const Text(
                        "AI",
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.psychology_outlined, color: Colors.white, size: 22),
                      const SizedBox(height: 6),
                      Text(
                        l10n.aiQuiz,
                        style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        l10n.anyTopic,
                        style: TextStyle(color: Colors.white.withValues(alpha: .8), fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTopicBottomSheet(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) {
        return _AiQuizTopicSheet(parentContext: context);
      },
    );
  }
}

class _AiQuizTopicSheet extends StatefulWidget {
  const _AiQuizTopicSheet({required this.parentContext});

  final BuildContext parentContext;

  @override
  State<_AiQuizTopicSheet> createState() => _AiQuizTopicSheetState();
}

class _AiQuizTopicSheetState extends State<_AiQuizTopicSheet> {
  final TextEditingController _topicController = TextEditingController();
  List<String> _recents = const [];

  @override
  void initState() {
    super.initState();
    _loadRecents();
  }

  Future<void> _loadRecents() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _recents = pref.getStringList(_kAiRecentsKey) ?? const [];
    });
  }

  Future<void> _saveRecents(String topic) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final List<String> updated = <String>[topic, ..._recents.where((String t) => t.toLowerCase() != topic.toLowerCase())];
    if (updated.length > _kAiRecentsMax) {
      updated.removeRange(_kAiRecentsMax, updated.length);
    }
    setState(() => _recents = updated);
    await pref.setStringList(_kAiRecentsKey, updated);
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: colorScheme.onSurfaceVariant.withValues(alpha: .4), borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.tertiary], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.generateAiQuiz,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(l10n.aiQuizDescription, style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 20),
            TextField(
              controller: _topicController,
              autofocus: true,
              textInputAction: TextInputAction.done,
              maxLines: 2,
              minLines: 1,
              decoration: InputDecoration(
                hintText: l10n.aiQuizTopicHint,
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                prefixIcon: const Icon(Icons.lightbulb_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
              ),
              onSubmitted: (_) => _handleGenerate(),
            ),
            if (_recents.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              SizedBox(
                height: 36,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      for (final String keyword in _recents)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ActionChip(
                            label: Text(keyword),
                            avatar: const Icon(Icons.history, size: 16),
                            onPressed: () {
                              _topicController.text = keyword;
                              _topicController.selection = TextSelection.fromPosition(TextPosition(offset: _topicController.text.length));
                              setState(() {});
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.tertiary], begin: Alignment.centerLeft, end: Alignment.centerRight),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton.icon(
                  onPressed: _handleGenerate,
                  icon: const Icon(Icons.auto_awesome, color: Colors.white),
                  label: Text(
                    l10n.generate,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleGenerate() {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final String topic = _topicController.text.trim();
    if (topic.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.pleaseEnterTopic), backgroundColor: colorScheme.error));
      return;
    }
    _saveRecents(topic);
    Navigator.of(context).pop();
    Navigator.of(widget.parentContext).push(MaterialPageRoute(builder: (_) => QuizPage(aiTopic: topic)));
  }
}
