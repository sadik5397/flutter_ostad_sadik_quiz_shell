import 'package:flutter/material.dart';
import 'package:quiz_shell/views/home_page.dart';

import '../service/database_service.dart';
import '../service/user_data.dart';

class QuizResult extends StatelessWidget {
  const QuizResult({super.key, required this.totalQuestions, required this.totalCorrect, required this.obtainedMark});

  final int totalQuestions;
  final int totalCorrect;
  final int obtainedMark;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 32), child: Image.asset("asset/congrats.png")),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CircleAvatar(radius: screenWidth * 0.12, backgroundColor: Colors.white, backgroundImage: NetworkImage(UserData.userImageUrl)),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                "Your Score",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54),
              ),
              Text(
                "$totalCorrect/$totalQuestions",
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xff2200a6)),
              ),
              const SizedBox(height: 16),
              const Text(
                "Congratulations!",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xff2200a6)),
              ),
              const SizedBox(height: 8),
              const Text(
                "Great job! You have done well",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black45, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(color: Color(0xfff6f4fc), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    CircleAvatar(radius: 16, backgroundColor: Color(0xfff4e2fa), foregroundColor: Colors.pinkAccent, child: Icon(Icons.diamond_outlined, size: 20)),
                    StreamBuilder<int>(
                      stream: DatabaseService().totalScoreStream,
                      builder: (context, asyncSnapshot) {
                        return Text(
                          asyncSnapshot.hasData ? asyncSnapshot.data.toString() : "0",
                          style: TextStyle(color: Color(0xff220c87), fontSize: 16, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SafeArea(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2200a6),
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "Back to Home",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
