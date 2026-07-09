import 'package:flutter/material.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';

class RecentCard extends StatelessWidget {
  const RecentCard({super.key, required this.title, required this.gainedScore, required this.totalCorrect, required this.totalAttempt, required this.playedOn});

  final String title;
  final int gainedScore;
  final int totalCorrect;
  final int totalAttempt;
  final String playedOn;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      tileColor: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
      ),
      subtitle: Text("${l10n.playedOn}: $playedOn", style: TextStyle(color: colorScheme.onSurfaceVariant)),
      leading: Container(
        height: 48,
        width: 48,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(6)),
        child: Text(
          gainedScore.toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer),
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
        child: Text(
          "$totalCorrect / $totalAttempt",
          style: TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
