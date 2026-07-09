import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_shell/service/database_service.dart';
import 'package:quiz_shell/views/collect_mobile_number.dart';
import 'package:quiz_shell/views/subscription_gate.dart';
import 'package:quiz_shell/widgets/quiz_loading_shimmer.dart';

/// After Google sign-in we still need to know whether the user has
/// saved a mobile number in Firestore. If not, we send them to a
/// dedicated form before letting them into MainShell. Once the mobile
/// number is on file, we additionally verify that the user is
/// subscribed to the BDApps service; if not, we send them to a
/// dedicated subscribe page.
class PostSignInRouter extends StatelessWidget {
  const PostSignInRouter({super.key, required this.user, required this.databaseService});

  final User user;
  final DatabaseService databaseService;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: databaseService.getUserDocument(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: QuizLoadingShimmer()));
        }
        final data = snapshot.data;
        final mobileValue = data?['mobileNumber'];
        final mobile = (mobileValue is String && mobileValue.trim().isNotEmpty) ? mobileValue.trim() : null;
        if (mobile == null) return const CollectMobileNumberPage();
        return SubscriptionGate(mobileNumber: mobile);
      },
    );
  }
}
