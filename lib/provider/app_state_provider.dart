import 'package:flutter/material.dart';
import 'package:quiz_shell/theme/theme.dart';

class AppStateProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  void toggleTheme(BuildContext context) {
    if (AppTheme.isDark(context)) {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }
}
