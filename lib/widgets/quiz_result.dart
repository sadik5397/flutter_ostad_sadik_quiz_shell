import 'package:flutter/material.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:quiz_shell/theme/theme_padding.dart';
import 'package:quiz_shell/views/main_shell.dart';

import '../service/database_service.dart';
import '../service/user_data.dart';

class QuizResult extends StatelessWidget {
  const QuizResult({super.key, required this.totalQuestions, required this.totalCorrect, required this.obtainedMark});

  final int totalQuestions;
  final int totalCorrect;
  final int obtainedMark;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 32), child: Image.asset("asset/congrats.png")),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CircleAvatar(radius: screenWidth * 0.12, backgroundColor: colorScheme.surface, backgroundImage: NetworkImage(UserData.userImageUrl)),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                l10n.yourScore,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: colorScheme.onSurfaceVariant),
              ),
              Text(
                "$totalCorrect/$totalQuestions",
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: colorScheme.primary),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.congratulations,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colorScheme.primary),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.greatJob,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              Container(
                padding: ThemePadding.all,
                decoration: BoxDecoration(color: colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    CircleAvatar(radius: 16, backgroundColor: colorScheme.secondary, foregroundColor: colorScheme.onSecondary, child: const Icon(Icons.diamond_outlined, size: 20)),
                    StreamBuilder<int>(
                      stream: DatabaseService().totalScoreStream,
                      builder: (context, asyncSnapshot) {
                        return Text(
                          "${asyncSnapshot.hasData ? asyncSnapshot.data : 0} ${l10n.points}",
                          style: TextStyle(color: colorScheme.onSecondaryContainer, fontSize: 16, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SafeArea(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainShell()), (route) => false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    l10n.backToHome,
                    style: TextStyle(color: colorScheme.onPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
