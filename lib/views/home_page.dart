import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:quiz_shell/provider/category_provider.dart';
import 'package:quiz_shell/service/database_service.dart';
import 'package:quiz_shell/theme/theme_border_radius.dart';
import 'package:quiz_shell/theme/theme_padding.dart';
import 'package:quiz_shell/theme/theme_spacing.dart';
import 'package:quiz_shell/views/leaderboard.dart';
import 'package:quiz_shell/widgets/banner_card.dart';
import 'package:quiz_shell/widgets/category_card.dart';
import 'package:quiz_shell/widgets/home_page_header.dart';
import 'package:quiz_shell/widgets/recent_card.dart';
import 'package:quiz_shell/widgets/title_section.dart';

import '../model/quiz_category_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryProvider>().initiate(context);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => await context.read<CategoryProvider>().loadQuizCategories(context),
          child: ListView(
            padding: ThemePadding.all,
            children: [
              const HomePageHeader(),
              ThemeSpacing.vertical,
              const BannerCard(),
              ThemeSpacing.verticalX2,
              TitleSection(label: l10n.subject),
              ThemeSpacing.vertical,
              Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child) => categoryProvider.allCategories.isEmpty
                    ? const LinearProgressIndicator()
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: ThemeSpacing.value,
                          children: List.generate(categoryProvider.allCategories.length, (index) {
                            QuizCategory cat = categoryProvider.allCategories[index];
                            return CategoryCard(category: cat);
                          }),
                        ),
                      ),
              ),
              ThemeSpacing.vertical,
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Leaderboard())),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
                  fixedSize: const WidgetStatePropertyAll(Size(double.maxFinite, 56)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: ThemeBorderRadius.all)),
                ),
                child: Text(
                  l10n.checkLeaderboard,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onPrimary),
                ),
              ),
              ThemeSpacing.verticalX2,
              TitleSection(label: l10n.recent, showSeeAll: false),
              ThemeSpacing.vertical,
              StreamBuilder<QuerySnapshot>(
                stream: DatabaseService().sessionHistoryStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const LinearProgressIndicator();
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Text("No Quiz Played Yet");
                  return Column(
                    children: snapshot.data!.docs.map((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: RecentCard(
                          title: data['quizCategory'] ?? '--',
                          totalAttempt: data['totalAttempt'] ?? '--',
                          totalCorrect: data['totalCorrect'] ?? '--',
                          gainedScore: data['gainedScore'] ?? '--',
                          playedOn: data['dateTime'] != null ? (data['dateTime'] as Timestamp).toDate().toString().split(" ").first : '--',
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
