import 'package:flutter/material.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:quiz_shell/theme/theme_border_radius.dart';
import 'package:quiz_shell/views/quiz_categories.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: ThemeBorderRadius.all,
        image: DecorationImage(image: AssetImage("asset/card_bg.png"), fit: BoxFit.cover),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.playAndWin,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            l10n.startQuizNow,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizCategories())),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(colorScheme.onPrimary),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 6,
              children: [
                Text(
                  l10n.getStarted,
                  style: TextStyle(color: colorScheme.primary, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: colorScheme.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
