import 'package:flutter/material.dart';
import 'package:quiz_shell/service/bdapps_service.dart';
import 'package:quiz_shell/service/user_data.dart';
import 'package:quiz_shell/views/main_shell.dart';
import 'package:quiz_shell/widgets/quiz_loading_shimmer.dart';

/// Asks the BDApps backend whether [mobileNumber] is currently
/// REGISTERED, but always lands the user on [MainShell]. The BDApps
/// status is only used as a hint for the rest of the app — the
/// `QuizPage` entry points (via [SubscriptionGuard] in the category /
/// AI quiz cards) and the profile screen will surface the subscribe
/// prompt when needed, so the rest of the app stays usable while a
/// subscription is missing.
///
/// We deliberately do not block on the subscription here: a user who
/// already has a mobile number on file should not be sent back to
/// the subscribe page just because the BDApps backend reports them
/// as not-yet-registered.
class SubscriptionGate extends StatelessWidget {
  const SubscriptionGate({super.key, required this.mobileNumber});

  final String mobileNumber;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: BdappsService.isSubscribed(mobileNumber),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: QuizLoadingShimmer()));
        }
        UserData.isSubscribed = snapshot.data ?? false;
        return const MainShell();
      },
    );
  }
}
