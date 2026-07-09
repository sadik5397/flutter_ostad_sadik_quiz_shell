import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';

import '../provider/app_state_provider.dart';
import '../provider/locale_provider.dart';
import '../service/auth_service.dart';
import '../service/database_service.dart';
import '../service/user_data.dart';
import '../theme/theme.dart';
import '../theme/theme_padding.dart';
import '../theme/theme_spacing.dart';
import '../widgets/profile_info_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Cached snapshot of the underlying UserData values. The screen
  // rebuilds after the edit-phone dialog writes back to UserData so
  // the badge / button toggle without needing a global notifier.
  String _mobileNumber = UserData.userMobileNumber;
  bool _isSubscribed = UserData.isSubscribed;

  void _syncFromUserData() {
    _mobileNumber = UserData.userMobileNumber;
    _isSubscribed = UserData.isSubscribed;
  }

  Future<void> _editPhoneNumber() async {
    final l10n = AppLocalizations.of(context)!;

    final newMobile = await showDialog<String>(
      context: context,
      builder: (_) => _EditPhoneNumberDialog(initialValue: _mobileNumber),
    );

    if (newMobile == null || !mounted) return;

    setState(() => _syncFromUserData());

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.phoneNumberUpdated)));
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(backgroundColor: colorScheme.surface, title: Text(l10n.myProfile), centerTitle: true),
      body: SingleChildScrollView(
        padding: ThemePadding.all,
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Image
            Center(
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.primary, width: 3),
                  image: DecorationImage(image: NetworkImage(UserData.userImageUrl), fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Subscription badge OR edit-phone-number button.
            if (_isSubscribed)
              _SubscribedBadge(label: l10n.subscribed)
            else
              OutlinedButton.icon(
                onPressed: _editPhoneNumber,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: Text(l10n.editPhoneNumber),
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              ),
            ThemeSpacing.vertical,
            ThemeSpacing.vertical, // User Information Card
            Card(
              elevation: 0,
              color: colorScheme.surface,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: colorScheme.outlineVariant),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ProfileInfoTile(icon: Icons.person, label: l10n.name, value: UserData.userName),
                    Divider(height: 24, color: colorScheme.outlineVariant),
                    ProfileInfoTile(icon: Icons.email, label: l10n.email, value: UserData.userEmail),
                    Divider(height: 24, color: colorScheme.outlineVariant),
                    ProfileInfoTile(icon: Icons.phone, label: l10n.mobileNumber, value: UserData.userMobileNumber),
                    Divider(height: 24, color: colorScheme.outlineVariant),
                    ProfileInfoTile(icon: Icons.calendar_today, label: l10n.joined, value: UserData.userJoined),
                  ],
                ),
              ),
            ),
            ThemeSpacing.vertical, // Language Switch Card
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              color: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: colorScheme.outlineVariant),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<LocaleProvider>(
                  builder: (context, localeProvider, child) {
                    return ListTile(
                      title: Text(
                        l10n.language,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colorScheme.onSurface),
                      ),
                      subtitle: Text(localeProvider.locale.languageCode == 'en' ? l10n.english : l10n.bangla, style: TextStyle(color: colorScheme.onSurfaceVariant)),
                      leading: Icon(Icons.language, color: colorScheme.primary),
                      trailing: DropdownButton<String>(
                        value: localeProvider.locale.languageCode,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        underline: Container(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            localeProvider.setLocale(Locale(newValue));
                          }
                        },
                        items: [
                          DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                          DropdownMenuItem(value: 'bn', child: Text(l10n.bangla)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            ThemeSpacing.vertical,
            // Theme Switch Card
            Card(
              elevation: 0,
              color: colorScheme.surface,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: colorScheme.outlineVariant),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<AppStateProvider>(
                  builder: (context, appState, child) {
                    return SwitchListTile(
                      title: Text(
                        l10n.switchTheme,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colorScheme.onSurface),
                      ),
                      subtitle: Text(AppTheme.isDark(context) ? l10n.dark : l10n.light, style: TextStyle(color: colorScheme.onSurfaceVariant)),
                      secondary: Icon(AppTheme.isDark(context) ? Icons.dark_mode : Icons.light_mode, color: colorScheme.primary),
                      value: AppTheme.isDark(context),
                      onChanged: (bool value) {
                        appState.toggleTheme(context);
                      },
                      activeThumbColor: colorScheme.primary,
                    );
                  },
                ),
              ),
            ),
            ThemeSpacing.vertical, // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async => await AuthService().signOut(context),
                icon: Icon(Icons.logout, color: colorScheme.onError),
                label: Text(
                  l10n.signOut,
                  style: TextStyle(color: colorScheme.onError, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            ThemeSpacing.vertical, ThemeSpacing.vertical,
          ],
        ),
      ),
    );
  }
}

/// A small green pill indicating the user has an active BDApps
/// subscription. Used on the profile page when [UserData.isSubscribed]
/// is `true`. Color falls back to a hard-coded green so the badge reads
/// as "success" in both light and dark themes.
class _SubscribedBadge extends StatelessWidget {
  const _SubscribedBadge({required this.label});

  final String label;

  static const Color _successGreen = Color(0xFF16A34A);
  static const Color _onSuccessGreen = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: _successGreen, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.verified, color: _onSuccessGreen, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: _onSuccessGreen, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.2),
          ),
        ],
      ),
    );
  }
}

/// A modal dialog that lets the user update the mobile number
/// associated with their Firestore document. Returned to the caller
/// via `Navigator.pop(value)` so the profile page can refresh its
/// profile info tile.
///
/// The widget is a proper `StatefulWidget` (not a `StatefulBuilder`
/// closure) so the [TextEditingController] lifetime is managed
/// correctly, and the [Column] body is wrapped in a
/// [SingleChildScrollView] so the dialog never overflows when the
/// keyboard is up.
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
      // Wrap the body in a scroll view so it can never exceed the
      // available height (the default dialog content shrinks, but a
      // tall Column with a TextField can overflow when the keyboard is
      // shown).
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
                keyboardType: TextInputType.phone,
                autofocus: true,
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
