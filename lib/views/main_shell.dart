import 'package:flutter/material.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:quiz_shell/views/home_page.dart';
import 'package:quiz_shell/views/leaderboard.dart';
import 'package:quiz_shell/views/profile_page.dart';
import 'package:quiz_shell/views/quiz_categories.dart';

import 'manage_categories.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[HomePage(), QuizCategories(), Leaderboard(), ManageCategories(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) => setState(() => _selectedIndex = index),
        destinations: <NavigationDestination>[
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: l10n.home),
          NavigationDestination(icon: const Icon(Icons.category_outlined), selectedIcon: const Icon(Icons.category), label: l10n.categories),
          NavigationDestination(icon: const Icon(Icons.leaderboard_outlined), selectedIcon: const Icon(Icons.leaderboard), label: l10n.leaderboard),
          NavigationDestination(icon: const Icon(Icons.admin_panel_settings_outlined), selectedIcon: const Icon(Icons.admin_panel_settings), label: l10n.admin),
          NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: l10n.profile),
        ],
      ),
    );
  }
}
