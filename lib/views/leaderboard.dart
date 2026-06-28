import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:quiz_shell/service/auth_service.dart';
import 'package:quiz_shell/service/database_service.dart';
import 'package:quiz_shell/service/user_data.dart';
import 'package:quiz_shell/theme/theme.dart';
import 'package:quiz_shell/widgets/podium_item.dart';
import 'package:quiz_shell/widgets/ranked_item.dart';
import 'package:quiz_shell/widgets/stat_item.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text(l10n.leaderboard),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService().allUsersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No data available"));
          }

          //users
          final List<DocumentSnapshot> users = snapshot.data!.docs;
          //myUid
          final String? myUserId = AuthService().currentUser?.uid;
          //myRank
          int myRank = -1;
          //myData
          Map<String, dynamic>? myData;
          //calculate myRank and myData
          for (int i = 0; i < users.length; i++) {
            if (users[i].id == myUserId) {
              myRank = i + 1;
              myData = users[i].data() as Map<String, dynamic>;
            }
          }
          //first 3 users
          final user1 = users.isNotEmpty ? users[0].data() as Map<String, dynamic> : null;
          final user2 = users.length > 1 ? users[1].data() as Map<String, dynamic> : null;
          final user3 = users.length > 2 ? users[2].data() as Map<String, dynamic> : null;

          //baki users
          final List<DocumentSnapshot> rankedUsers = users.length > 3 ? users.sublist(3) : [];

          return ListView(
            children: [
              //Podium
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    opacity: AppTheme.isDark(context) ? .1 : 1,
                    image: const AssetImage("asset/stage.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 12,
                      children: [
                        PodiumItem(
                          rank: 2,
                          name: user2?["displayName"] ?? "--",
                          points: user2?["totalScore"] ?? 0,
                          imageUrl: user2?["photo"] ?? UserData.placeholderImageUrl,
                          color: Colors.purple,
                        ),
                        PodiumItem(
                          rank: 1,
                          name: user1?["displayName"] ?? "--",
                          points: user1?["totalScore"] ?? 0,
                          imageUrl: user1?["photo"] ?? UserData.placeholderImageUrl,
                          color: Colors.pink,
                        ),
                        PodiumItem(
                          rank: 3,
                          name: user3?["displayName"] ?? "--",
                          points: user3?["totalScore"] ?? 0,
                          imageUrl: user3?["photo"] ?? UserData.placeholderImageUrl,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    //MyStat
                    Card(
                      color: colorScheme.surface,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          StatItem(icon: Icons.bar_chart, label: l10n.yourRank, value: "#$myRank", color: const Color(0xff8a82f3)),
                          StatItem(icon: Icons.diamond_outlined, label: l10n.totalPoints, value: (myData?["totalScore"] ?? 0).toString(), color: Colors.pinkAccent),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //RankedList
              const SizedBox(height: 12),
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: rankedUsers.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> user = rankedUsers[index].data() as Map<String, dynamic>;
                  bool isMyself = user["email"] == UserData.userEmail;
                  return RankedItem(
                    rank: index + 4,
                    imageUrl: user["photo"] ?? UserData.placeholderImageUrl,
                    name: isMyself ? l10n.you : (user["displayName"] ?? ""),
                    points: user["totalScore"] ?? 0,
                    isMyself: isMyself,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
