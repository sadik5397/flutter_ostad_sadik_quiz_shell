import 'package:flutter/material.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';

import '../service/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz, size: 100, color: colorScheme.primary),
            const SizedBox(height: 20),
            Text(
              l10n.appTitle,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: _isSigningIn
                  ? null
                  : () async {
                      setState(() {
                        _isSigningIn = true;
                      });

                      final user = await AuthService().signInWithGoogle();
                      if (!context.mounted) {
                        return;
                      }

                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.signInFailed)));
                      }

                      setState(() {
                        _isSigningIn = false;
                      });
                    },
              icon: Image.network('http://pngimg.com/uploads/google/google_PNG19635.png', height: 24),
              label: Text(_isSigningIn ? l10n.signingIn : l10n.signInWithGoogle),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.surface,
                foregroundColor: colorScheme.onSurface,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: colorScheme.outline),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
