import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';

import '../provider/app_state_provider.dart';
import '../provider/locale_provider.dart';
import '../service/auth_service.dart';
import '../service/user_data.dart';
import '../theme/theme.dart';
import '../widgets/profile_info_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text(l10n.myProfile),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
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
                  image: DecorationImage(
                    image: NetworkImage(UserData.userImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // User Information Card
            Card(
              elevation: 4,
              color: colorScheme.surface,
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
                    ProfileInfoTile(icon: Icons.calendar_today, label: l10n.joined, value: UserData.userJoined),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Language Switch Card
            Card(
              elevation: 4,
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        localeProvider.locale.languageCode == 'en' ? l10n.english : l10n.bangla,
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
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
            const SizedBox(height: 16),
            // Theme Switch Card
            Card(
              elevation: 4,
              color: colorScheme.surface,
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        AppTheme.isDark(context) ? l10n.dark : l10n.light,
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                      secondary: Icon(
                        AppTheme.isDark(context) ? Icons.dark_mode : Icons.light_mode,
                        color: colorScheme.primary,
                      ),
                      value: AppTheme.isDark(context),
                      onChanged: (bool value) {
                        appState.toggleTheme(context);
                      },
                      activeColor: colorScheme.primary,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async => await AuthService().signOut(context),
                icon: Icon(Icons.logout, color: colorScheme.onError),
                label: Text(
                  l10n.signOut,
                  style: TextStyle(
                    color: colorScheme.onError,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
