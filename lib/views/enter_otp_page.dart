import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:quiz_shell/service/auth_service.dart';
import 'package:quiz_shell/service/bdapps_service.dart';
import 'package:quiz_shell/service/user_data.dart';
import 'package:quiz_shell/views/main_shell.dart';
import 'package:quiz_shell/views/sign_in.dart';
import 'package:quiz_shell/widgets/quiz_loading_shimmer.dart';
import 'package:sms_autofill/sms_autofill.dart';

/// Page that asks the user to enter the 6-digit OTP that was sent to
/// [mobileNumber] by the BDApps backend. The matching [referenceNo] is
/// required to verify the code.
///
/// The page uses `sms_autofill` (Google Play Services SMS Retriever
/// API on Android, system OTP autofill on iOS) to detect an incoming
/// SMS and pre-fill the input automatically.
class EnterOtpPage extends StatefulWidget {
  const EnterOtpPage({super.key, required this.mobileNumber, required this.referenceNo, this.onVerified});

  final String mobileNumber;
  final String referenceNo;

  /// Optional callback fired after a successful verification. The
  /// caller is then responsible for navigation. When `null`, the page
  /// pops with `true` as the result.
  final VoidCallback? onVerified;

  @override
  State<EnterOtpPage> createState() => _EnterOtpPageState();
}

class _EnterOtpPageState extends State<EnterOtpPage> {
  static const int _codeLength = 6;

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  StreamSubscription<String>? _smsSubscription;
  bool _isVerifying = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_codeLength, (_) => TextEditingController());
    _focusNodes = List.generate(_codeLength, (_) => FocusNode());
    for (var i = 0; i < _codeLength; i++) {
      _controllers[i].addListener(_onAnyDigitChanged);
    }

    // Start the SMS Retriever listener and pre-fill digits as they come
    // in. We match any 6-digit run inside the SMS body.
    _smsSubscription = SmsAutoFill().code.listen(_applyAutoFill);
    SmsAutoFill().listenForCode(smsCodeRegexPattern: r'\d{6}');
  }

  @override
  void dispose() {
    _smsSubscription?.cancel();
    SmsAutoFill().unregisterListener();
    for (var i = 0; i < _codeLength; i++) {
      _controllers[i].removeListener(_onAnyDigitChanged);
      _controllers[i].dispose();
      _focusNodes[i].dispose();
    }
    super.dispose();
  }

  Future<void> _signOutIfNeeded() async {
    if (FirebaseAuth.instance.currentUser == null) {
      await AuthService().googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false);
    }
  }

  void _onAnyDigitChanged() {
    if (_errorText != null) {
      setState(() => _errorText = null);
    }
  }

  void _applyAutoFill(String code) {
    if (!mounted) return;
    final digits = code.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < _codeLength) return;
    final trimmed = digits.substring(0, _codeLength);
    for (var i = 0; i < _codeLength; i++) {
      _controllers[i].text = trimmed[i];
    }
    // Move focus off the last field so the on-screen keyboard
    // dismisses — feels more natural once the code is fully filled.
    _focusNodes[_codeLength - 1].unfocus();
    setState(() => _errorText = null);
  }

  String get _currentCode => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < _codeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_currentCode.length == _codeLength && !_isVerifying) {
      // Auto-submit once the user has typed all six digits.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _verify();
      });
    }
  }

  void _onBackspace(int index, KeyEvent event) {
    if (event is! KeyDownEvent) return;
    if (event.logicalKey != LogicalKeyboardKey.backspace) return;
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verify() async {
    final l10n = AppLocalizations.of(context)!;
    if (_isVerifying) return;
    final code = _currentCode;
    if (code.length != _codeLength) {
      setState(() => _errorText = l10n.pleaseEnterOtp);
      return;
    }
    FocusScope.of(context).unfocus();

    setState(() {
      _isVerifying = true;
      _errorText = null;
    });

    try {
      final res = await BdappsService.verifyOtp(code, widget.referenceNo);
      if (!mounted) return;
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.otpVerified)));
        if (widget.onVerified != null) {
          widget.onVerified!.call();
          return;
        }
        Navigator.of(context).pop(true);
        return;
      }
      setState(() => _errorText = l10n.otpVerificationFailed);
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorText = l10n.otpVerificationFailed);
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  Future<void> _resend() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final res = await BdappsService.sendOtp(widget.mobileNumber);
      if (!mounted) return;
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.otpSent)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.otpSendFailed), backgroundColor: Theme.of(context).colorScheme.error));
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.otpSendFailed), backgroundColor: Theme.of(context).colorScheme.error));
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
      appBar: AppBar(backgroundColor: colorScheme.surface, elevation: 0, title: Text(l10n.enterOtpTitle), centerTitle: true),
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
                  child: Icon(Icons.sms_outlined, size: 40, color: colorScheme.onPrimaryContainer),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.enterOtpDescription,
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
                  subtitle: Text(widget.mobileNumber),
                ),
              ),
              const SizedBox(height: 28),
              _OtpFieldRow(
                controllers: _controllers,
                focusNodes: _focusNodes,
                onDigitChanged: _onDigitChanged,
                onBackspace: _onBackspace,
                hasError: _errorText != null,
                colorScheme: colorScheme,
              ),
              if (_errorText != null) ...<Widget>[
                const SizedBox(height: 12),
                Text(
                  _errorText!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: colorScheme.error, fontWeight: FontWeight.w500),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.sms_outlined, size: 16, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(l10n.otpAutoFillHint, style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                ],
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isVerifying ? null : _verify,
                  icon: _isVerifying
                      ? SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.4, valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary)))
                      : const Icon(Icons.verified_outlined),
                  label: Text(l10n.verify, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(onPressed: _isVerifying ? null : _resend, icon: const Icon(Icons.refresh, size: 18), label: Text(l10n.resendOtp)),
              const SizedBox(height: 12),
              Text(
                l10n.otpPageHint,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Renders [_codeLength] single-digit fields with auto-advance,
/// backspace-to-previous, and `AutofillHints.oneTimeCode` for SMS
/// autofill support.
class _OtpFieldRow extends StatelessWidget {
  const _OtpFieldRow({required this.controllers, required this.focusNodes, required this.onDigitChanged, required this.onBackspace, required this.hasError, required this.colorScheme});

  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(int index, String value) onDigitChanged;
  final void Function(int index, KeyEvent event) onBackspace;
  final bool hasError;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        for (var i = 0; i < controllers.length; i++)
          _OtpDigitField(
            controller: controllers[i],
            focusNode: focusNodes[i],
            onChanged: (value) => onDigitChanged(i, value),
            onKeyEvent: (event) => onBackspace(i, event),
            hasError: hasError,
            colorScheme: colorScheme,
          ),
      ],
    );
  }
}

class _OtpDigitField extends StatelessWidget {
  const _OtpDigitField({required this.controller, required this.focusNode, required this.onChanged, required this.onKeyEvent, required this.hasError, required this.colorScheme});

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<KeyEvent> onKeyEvent;
  final bool hasError;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final borderColor = hasError ? colorScheme.error : colorScheme.outlineVariant;
    final fillColor = hasError ? colorScheme.errorContainer.withValues(alpha: 0.25) : colorScheme.surfaceContainerLow;

    return SizedBox(
      width: 46,
      child: KeyboardListener(
        focusNode: FocusNode(skipTraversal: true),
        onKeyEvent: onKeyEvent,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          autofillHints: const <String>[AutofillHints.oneTimeCode],
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// Helper that lives at the bottom so it doesn't leak into other
/// files. Returns `true` when the user is already subscribed and we
/// should jump to the main shell.
Future<bool> isUserSubscribed(String mobile) async {
  return BdappsService.isSubscribed(mobile);
}

/// Updates the in-memory [UserData] flag and pushes the main shell
/// when the user has just become subscribed.
void goToMainIfSubscribed(BuildContext context, String mobile) async {
  final subscribed = await isUserSubscribed(mobile);
  if (!context.mounted) return;
  UserData.isSubscribed = subscribed;
  if (subscribed) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainShell()), (_) => false);
  }
}
