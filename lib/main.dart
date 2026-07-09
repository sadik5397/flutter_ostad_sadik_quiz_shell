import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:quiz_shell/provider/app_state_provider.dart';
import 'package:quiz_shell/provider/category_provider.dart';
import 'package:quiz_shell/provider/chat_provider.dart';
import 'package:quiz_shell/provider/locale_provider.dart';
import 'package:quiz_shell/provider/quiz_provider.dart';
import 'package:quiz_shell/service/hive_database.dart';
import 'package:quiz_shell/theme/theme.dart';
import 'package:quiz_shell/views/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await HiveDatabase.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppStateProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => QuizProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: Consumer2<AppStateProvider, LocaleProvider>(
        builder: (context, appStateProvider, localeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Quiz Shell',
            themeMode: appStateProvider.themeMode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            locale: localeProvider.locale,
            localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
            supportedLocales: const [Locale('en'), Locale('bn')],
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}
