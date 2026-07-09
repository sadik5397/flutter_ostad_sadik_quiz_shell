import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_shell/service/auth_service.dart';
import 'package:quiz_shell/service/database_service.dart';
import 'package:quiz_shell/views/post_sign_in_router.dart';
import 'package:quiz_shell/views/sign_in.dart';
import 'package:quiz_shell/widgets/quiz_loading_shimmer.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Future<User?> _restoreSessionFuture;

  // Bumped each time a user signs in or out, so we re-evaluate the
  // Firestore "has mobile number" check against the latest auth state.
  late final Stream<User?> _authStream;
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _restoreSessionFuture = AuthService().restoreSessionIfPossible();
    _authStream = FirebaseAuth.instance.authStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _restoreSessionFuture,
      builder: (context, restoreSnapshot) {
        if (restoreSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: QuizLoadingShimmer()));
        }

        return StreamBuilder<User?>(
          stream: _authStream,
          initialData: FirebaseAuth.instance.currentUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: QuizLoadingShimmer()));
            }
            if (snapshot.hasData) {
              return PostSignInRouter(user: snapshot.data!, databaseService: _databaseService);
            }
            return const LoginPage();
          },
        );
      },
    );
  }
}
