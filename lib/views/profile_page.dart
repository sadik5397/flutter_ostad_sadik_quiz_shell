import 'package:flutter/material.dart';

import '../service/auth_service.dart';
import '../service/user_data.dart';
import '../widgets/profile_info_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: const Text("My Profile"),
        centerTitle: true,
      ),
      body: Padding(
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
                    ProfileInfoTile(icon: Icons.person, label: "Name", value: UserData.userName),
                    Divider(height: 24, color: colorScheme.outlineVariant),
                    ProfileInfoTile(icon: Icons.email, label: "Email", value: UserData.userEmail),
                    Divider(height: 24, color: colorScheme.outlineVariant),
                    ProfileInfoTile(icon: Icons.calendar_today, label: "Joined", value: UserData.userJoined),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async => await AuthService().signOut(context),
                icon: Icon(Icons.logout, color: colorScheme.onError),
                label: Text(
                  "Sign Out",
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