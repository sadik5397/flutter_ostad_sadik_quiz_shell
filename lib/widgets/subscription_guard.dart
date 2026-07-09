import 'package:flutter/material.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:quiz_shell/service/user_data.dart';

/// Returns `true` when the user is allowed to start a quiz, or
/// `false` after showing a warning bottom sheet explaining the
/// subscription requirement.
///
/// Use this around `Navigator.push` calls into the quiz page.
class SubscriptionGuard {
  /// Show a non-dismissible-by-default warning if the user is not
  /// currently subscribed. Returns `true` if the caller may proceed
  /// with opening the quiz page.
  static bool canStart(BuildContext context) {
    if (UserData.isSubscribed) return true;
    _showNotSubscribedSheet(context);
    return false;
  }

  static void _showNotSubscribedSheet(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: colorScheme.onSurfaceVariant.withValues(alpha: .4), borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: colorScheme.errorContainer, borderRadius: BorderRadius.circular(12)),
                      child: Icon(Icons.lock_outline, color: colorScheme.onErrorContainer, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.subscriptionRequiredToPlayTitle,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(l10n.subscriptionRequiredToPlayDescription, style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant, height: 1.4)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(l10n.ok, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
