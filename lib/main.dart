import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_shell/provider/app_state_provider.dart';
import 'package:quiz_shell/provider/category_provider.dart';
import 'package:quiz_shell/provider/quiz_provider.dart';
import 'package:quiz_shell/service/hive_database.dart';
import 'package:quiz_shell/theme/theme.dart';
import 'package:quiz_shell/views/sign_in.dart';

import 'views/home_page.dart';

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
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => QuizProvider()),
      ],
      child: Consumer<AppStateProvider>(
        builder: (context, appStateProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Quiz Shell',
            themeMode: appStateProvider.themeMode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                if (snapshot.hasData) {
                  return const HomePage();
                }
                return const LoginPage();
              },
            ),
          );
        },
      ),
    );
  }
}
