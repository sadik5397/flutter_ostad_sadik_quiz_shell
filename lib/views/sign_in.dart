import 'package:flutter/material.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:quiz_shell/theme/theme_padding.dart';

import '../service/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigningIn = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isSigningIn = true);
    final user = await AuthService().signInWithGoogle();
    if (!mounted) return;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.signInFailed)));
    }
    setState(() => _isSigningIn = false);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: ThemePadding.all * 2,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 24),
                Image.asset("asset/app_logo.png", height: 120, width: 120),
                const SizedBox(height: 24),
                Text(
                  l10n.welcomeBack,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.aiPoweredQuizShell,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: _isSigningIn ? null : _handleGoogleSignIn,
                    icon: _isSigningIn
                        ? SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.4, valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary)))
                        : const Icon(Icons.g_mobiledata, size: 40),
                    label: Text(l10n.signInWithGoogle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  l10n.noNeedToSignUp,
                  style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
