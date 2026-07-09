import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:quiz_shell/service/auth_service.dart';
import 'package:quiz_shell/service/database_service.dart';
import 'package:quiz_shell/service/user_data.dart';
import 'package:quiz_shell/views/main_shell.dart';
import 'package:quiz_shell/views/sign_in.dart';
import 'package:quiz_shell/widgets/quiz_loading_shimmer.dart';

class CollectMobileNumberPage extends StatefulWidget {
  const CollectMobileNumberPage({super.key});

  @override
  State<CollectMobileNumberPage> createState() => _CollectMobileNumberPageState();
}

class _CollectMobileNumberPageState extends State<CollectMobileNumberPage> {
  final TextEditingController _mobileController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  // Helper: sign the user out if their account is missing in FirebaseAuth
  // (shouldn't happen here, but useful as a safety net for stale sessions).
  Future<void> _signOutIfNeeded() async {
    if (FirebaseAuth.instance.currentUser == null) {
      await AuthService().googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false);
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);
    final ok = await DatabaseService().saveMobileNumber(_mobileController.text.trim());
    if (!mounted) return;
    setState(() => _isSaving = false);

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.mobileSaveFailed), backgroundColor: Theme.of(context).colorScheme.error));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.mobileSaved)));
    // Replace this page so the user can't pop back to it.
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainShell()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    // Defensive: if AuthGate routes here accidentally without a user,
    // bounce back to the login screen instead of saving against a missing account.
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _signOutIfNeeded());
      return const Scaffold(body: Center(child: QuizLoadingShimmer()));
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(backgroundColor: colorScheme.surface, elevation: 0, title: Text(l10n.mobileNumber), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 16),
              Center(
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: colorScheme.primaryContainer,
                  backgroundImage: UserData.userImageUrl.isNotEmpty ? NetworkImage(UserData.userImageUrl) : null,
                  child: UserData.userImageUrl.isEmpty ? Icon(Icons.person, size: 44, color: colorScheme.onPrimaryContainer) : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.provideMobileNumberGreeting,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.provideMobileNumberDescription,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  autofocus: true,
                  enabled: !_isSaving,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: (value) {
                    final trimmed = (value ?? '').trim();
                    if (trimmed.isEmpty) return l10n.pleaseEnterMobileNumber;
                    // Accept 10–15 digits, optionally prefixed with + and a country code.
                    final regex = RegExp(r'^\+?[0-9]{10,15}$');
                    if (!regex.hasMatch(trimmed)) {
                      return l10n.pleaseEnterValidMobile;
                    }
                    return null;
                  },
                  style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone_android),
                    labelText: l10n.mobileNumber,
                    hintText: l10n.mobileNumberHint,
                    filled: true,
                    fillColor: colorScheme.surfaceContainerLow,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.primary, width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _submit,
                  icon: _isSaving
                      ? SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.4, valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary)))
                      : const Icon(Icons.check),
                  label: Text(_isSaving ? l10n.signingIn : l10n.continueLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(onPressed: _isSaving ? null : _signOutIfNeeded, icon: const Icon(Icons.logout, size: 18), label: Text(l10n.signOut)),
            ],
          ),
        ),
      ),
    );
  }
}
