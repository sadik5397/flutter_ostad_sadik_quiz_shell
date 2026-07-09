import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:quiz_shell/service/auth_service.dart';
import 'package:quiz_shell/service/bdapps_service.dart';
import 'package:quiz_shell/service/database_service.dart';
import 'package:quiz_shell/service/user_data.dart';
import 'package:quiz_shell/views/enter_otp_page.dart';
import 'package:quiz_shell/views/main_shell.dart';
import 'package:quiz_shell/views/sign_in.dart';
import 'package:quiz_shell/widgets/quiz_loading_shimmer.dart';

/// Page shown to a user who has a mobile number on file but is not
/// currently REGISTERED on the BDApps backend. The post-sign-in
/// router no longer hard-routes the user here — unsubscribed users
/// land in [MainShell] and the quiz entry points are gated separately
/// — so this page is only displayed when the user opens it
/// explicitly (e.g. from a profile action).
///
/// The page lets the user "Send OTP" to start the BDApps
/// subscription flow. Tapping that button calls the BDApps
/// `send_otp.php` endpoint and pushes [EnterOtpPage] to collect the
/// 6-digit code, passing back the `referenceNo` so the user can be
/// verified and subscribed.
class SubscribePage extends StatefulWidget {
  const SubscribePage({super.key, required this.mobileNumber});

  final String mobileNumber;

  @override
  State<SubscribePage> createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  bool _isChecking = false;

  // Cached snapshot of the mobile number on file. Updated whenever the
  // user changes it via the edit-phone dialog so the card, the
  // re-check, and the OTP request all use the latest value without
  // requiring a full page rebuild.
  String _mobileNumber = UserData.userMobileNumber;

  @override
  void initState() {
    super.initState();
    if (_mobileNumber.isEmpty) {
      _mobileNumber = widget.mobileNumber;
    }
  }

  Future<void> _signOutIfNeeded() async {
    if (FirebaseAuth.instance.currentUser == null) {
      await AuthService().googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false);
    }
  }

  Future<void> _refresh() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isChecking = true);
    final subscribed = await BdappsService.isSubscribed(_mobileNumber);
    if (!mounted) return;
    setState(() => _isChecking = false);
    UserData.isSubscribed = subscribed;

    if (subscribed) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainShell()), (_) => false);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.subscriptionNotActive), backgroundColor: Theme.of(context).colorScheme.error));
  }

  /// Shows a snackbar reporting a failed send-otp call, preferring the
  /// server-provided message ("Sorry, Your phone number is
  /// blacklisted...") over the generic localized fallback.
  void _showSendOtpError(String? serverMessage) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final detail = (serverMessage == null || serverMessage.trim().isEmpty) ? l10n.otpSendFailed : '${l10n.otpSendFailed}: $serverMessage';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(detail), backgroundColor: Theme.of(context).colorScheme.error, duration: const Duration(seconds: 6)));
  }

  /// Extracts a human-readable error message from a BDApps send-otp
  /// response. The backend usually returns HTTP 200 even for business
  /// errors and signals them through `success: false` plus fields like
  /// `message` / `statusDetail` / `statusCode`.
  String? _extractSendOtpMessage(String body) {
    try {
      final decoded = jsonDecode(body.trim());
      if (decoded is! Map) return null;

      // Business-level failure flag.
      final success = decoded['success'];
      if (success is bool && success) return null;

      for (final key in const ['message', 'statusDetail', 'statusMessage']) {
        final value = decoded[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
      final code = decoded['statusCode'];
      if (code is String && code.trim().isNotEmpty) {
        return code.trim();
      }
    } catch (_) {
      // Not JSON or unexpected shape — fall through to null.
    }
    return null;
  }

  Future<void> _sendOtp() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isChecking = true);
    try {
      final res = await BdappsService.sendOtp(_mobileNumber);
      if (!mounted) return;
      if (res.statusCode != 200) {
        _showSendOtpError(null);
        return;
      }

      // Parse the response. Expected shapes:
      //   Success: { "success": true,  "referenceNo": "88016..." }
      //   Failure: { "success": false, "message": "...", "statusCode": "E...",
      //              "referenceNo": null }
      String? referenceNo;
      String? failureMessage;
      try {
        final body = res.body.trim();
        if (body.isNotEmpty) {
          final decoded = jsonDecode(body);
          if (decoded is Map) {
            final ref = decoded['referenceNo'] ?? decoded['reference_no'] ?? decoded['refNo'];
            if (ref is String && ref.isNotEmpty) referenceNo = ref;
          }
          failureMessage = _extractSendOtpMessage(body);
        }
      } catch (_) {
        // Body wasn't JSON — fall through; the OTP page will require it.
      }

      if (referenceNo == null || referenceNo.isEmpty) {
        _showSendOtpError(failureMessage);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.otpSent)));

      await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => EnterOtpPage(mobileNumber: _mobileNumber, referenceNo: referenceNo!, onVerified: () => _handleVerified()),
          fullscreenDialog: true,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      _showSendOtpError(null);
    } finally {
      if (mounted) {
        setState(() => _isChecking = false);
      }
    }
  }

  /// Lets the user correct the mobile number on file. Mirrors the
  /// profile-page flow: opens a dialog, writes back to Firestore via
  /// [DatabaseService.saveMobileNumber], then re-checks the
  /// subscription against the new number so the page state stays in
  /// sync with [UserData.userMobileNumber].
  Future<void> _editPhoneNumber() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    final newMobile = await showDialog<String>(
      context: context,
      builder: (_) => _EditPhoneNumberDialog(initialValue: _mobileNumber),
    );

    if (newMobile == null || !mounted) return;

    setState(() {
      _mobileNumber = newMobile;
      UserData.userMobileNumber = newMobile;
    });

    messenger.showSnackBar(SnackBar(content: Text(l10n.phoneNumberUpdated)));

    // Re-check the subscription right away — a different number might
    // already be active.
    final subscribed = await BdappsService.isSubscribed(_mobileNumber);
    if (!mounted) return;
    UserData.isSubscribed = subscribed;
    if (subscribed) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainShell()), (_) => false);
    }
  }

  /// Triggered when the OTP page reports a successful verification.
  /// Re-checks the subscription status and either pushes the main
  /// shell or notifies the user that the subscription is still
  /// pending.
  Future<void> _handleVerified() async {
    final l10n = AppLocalizations.of(context)!;
    final subscribed = await BdappsService.isSubscribed(_mobileNumber);
    if (!mounted) return;
    UserData.isSubscribed = subscribed;
    // Pop the OTP page first so we don't stack it on top of this one.
    Navigator.of(context).pop();
    if (subscribed) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainShell()), (_) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.subscriptionNotActive), backgroundColor: Theme.of(context).colorScheme.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _signOutIfNeeded());
      return const Scaffold(body: Center(child: QuizLoadingShimmer()));
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(backgroundColor: colorScheme.surface, elevation: 0, title: Text(l10n.subscription), centerTitle: true),
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
                  child: UserData.userImageUrl.isEmpty ? Icon(Icons.subscriptions, size: 44, color: colorScheme.onPrimaryContainer) : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.subscriptionRequiredTitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.subscriptionRequiredDescription,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: colorScheme.outlineVariant),
                ),
                child: ListTile(
                  leading: Icon(Icons.phone, color: colorScheme.primary),
                  title: Text(l10n.mobileNumber),
                  subtitle: Text(_mobileNumber),
                  trailing: IconButton(onPressed: _isChecking ? null : _editPhoneNumber, icon: const Icon(Icons.edit_outlined, size: 18), tooltip: l10n.editPhoneNumber),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isChecking ? null : _refresh,
                  icon: _isChecking
                      ? SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.4, valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary)))
                      : const Icon(Icons.refresh),
                  label: Text(l10n.reCheckSubscription, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: _isChecking ? null : _sendOtp,
                  icon: _isChecking
                      ? SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.4, valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary)))
                      : const Icon(Icons.sms_outlined),
                  label: Text(l10n.sendOtp, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    side: BorderSide(color: colorScheme.primary, width: 1.4),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: _isChecking ? null : () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainShell()), (_) => false),
                icon: const Icon(Icons.schedule, size: 18),
                label: Text(l10n.maybeLater),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Modal dialog used by [SubscribePage] to update the mobile number on
/// file. Identical in behavior to the one used by the profile page —
/// it returns the new number to the caller via `Navigator.pop(value)`
/// so the page can refresh its state and re-check the subscription.
///
/// Re-implemented locally (instead of being shared) so the page stays
/// self-contained and the dialog can evolve with the subscription
/// flow without touching the profile page.
class _EditPhoneNumberDialog extends StatefulWidget {
  const _EditPhoneNumberDialog({required this.initialValue});

  final String initialValue;

  @override
  State<_EditPhoneNumberDialog> createState() => _EditPhoneNumberDialogState();
}

class _EditPhoneNumberDialogState extends State<_EditPhoneNumberDialog> {
  late final TextEditingController _controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _saving = true);
    final ok = await DatabaseService().saveMobileNumber(_controller.text.trim());
    if (!mounted) return;

    if (ok) {
      Navigator.of(context).pop(_controller.text.trim());
      return;
    }

    setState(() => _saving = false);
    messenger.showSnackBar(SnackBar(content: Text(l10n.phoneNumberUpdateFailed)));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.updatePhoneNumberTitle),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(l10n.updatePhoneNumberDescription, style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _controller,
                autofocus: true,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _onSave(),
                validator: (value) {
                  final trimmed = (value ?? '').trim();
                  if (trimmed.isEmpty) {
                    return l10n.pleaseEnterMobileNumber;
                  }
                  if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(trimmed)) {
                    return l10n.pleaseEnterValidMobile;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: l10n.mobileNumber,
                  hintText: l10n.mobileNumberHint,
                  prefixIcon: const Icon(Icons.phone_android),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(onPressed: _saving ? null : () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
        ElevatedButton(
          onPressed: _saving ? null : _onSave,
          child: _saving ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : Text(l10n.save),
        ),
      ],
    );
  }
}
