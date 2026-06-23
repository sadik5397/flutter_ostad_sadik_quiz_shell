import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_shell/service/database_service.dart';
import 'package:quiz_shell/views/admin_options.dart';
import 'package:quiz_shell/views/leaderboard.dart';
import 'package:quiz_shell/widgets/banner_card.dart';
import 'package:quiz_shell/widgets/category_card.dart';
import 'package:quiz_shell/widgets/home_page_header.dart';
import 'package:quiz_shell/widgets/recent_card.dart';
import 'package:quiz_shell/widgets/title_section.dart';

import '../model/quiz_category_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<QuizCategory> allCategories = [];

  @override
  void initState() {
    super.initState();
    loadQuizCategories();
  }

  Future<void> loadQuizCategories() async {
    String url = "https://sadiks-quiz-apihub.lovable.app/api/v1/categories";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      List data = result["data"];
      setState(() => allCategories = data.map((item) => QuizCategory.fromJson(item)).toList());
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to load categories")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => await loadQuizCategories(),
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              HomePageHeader(),
              SizedBox(height: 16),
              BannerCard(),
              SizedBox(height: 32),
              TitleSection(label: "Subject"),
              SizedBox(height: 16),
              allCategories.isEmpty
                  ? LinearProgressIndicator()
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 12,
                        children: List.generate(allCategories.length, (index) {
                          QuizCategory cat = allCategories[index];
                          return CategoryCard(category: cat);
                        }),
                      ),
                    ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Leaderboard())),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Color(0xff2c2199)),
                  fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, 56)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12))),
                ),
                child: Text(
                  "Check Leaderboard",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              TitleSection(label: "Recent", showSeeAll: false),
              SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: DatabaseService().sessionHistoryStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return LinearProgressIndicator();
                  if (!snapshot.hasData) return Text("No Quiz Played Yet");
                  return Column(
                    children: snapshot.data!.docs.map((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: RecentCard(
                          title: data['quizCategory'] ?? '--',
                          totalAttempt: data['totalAttempt'] ?? '--',
                          totalCorrect: data['totalCorrect'] ?? '--',
                          gainedScore: data['gainedScore'] ?? '--',
                          playedOn: data['dateTime'] != null ? (data['dateTime'] as Timestamp).toDate().toString().split(" ").first : '--',
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AdminOptions())),
                style: ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, 56)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12))),
                ),
                child: Text("Admin Options", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
