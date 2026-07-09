import 'package:flutter/material.dart';
import 'package:quiz_shell/service/bdapps_service.dart';
import 'package:quiz_shell/service/user_data.dart';
import 'package:quiz_shell/views/main_shell.dart';
import 'package:quiz_shell/views/subscribe_page.dart';
import 'package:quiz_shell/widgets/quiz_loading_shimmer.dart';

/// Asks the BDApps backend whether [mobileNumber] is currently
/// REGISTERED. Either way the user is dropped into [MainShell] — we
/// only block the `QuizPage` itself (via [SubscriptionGuard] in the
/// category / AI quiz cards), so the rest of the app stays usable
/// while a subscription is missing.
///
/// The result is also cached into [UserData.isSubscribed] so the rest
/// of the app (profile badge, quiz gate, etc.) can read it
/// synchronously.
class SubscriptionGate extends StatelessWidget {
  const SubscriptionGate({super.key, required this.mobileNumber});

  final String mobileNumber;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: BdappsService.isSubscribed(mobileNumber),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return const Scaffold(body: Center(child: QuizLoadingShimmer()));
        final subscribed = snapshot.data ?? false;
        UserData.isSubscribed = subscribed;
        // SubscriptionGuard will block the QuizPage entry points
        // (category / AI quiz cards) and the profile screen will
        // surface the subscribe prompt.
        return UserData.isSubscribed ? MainShell() : SubscribePage(mobileNumber: mobileNumber);
      },
    );
  }
}
