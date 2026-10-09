import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_shell/service/auth_service.dart';
import 'package:quiz_shell/service/user_data.dart';

class DatabaseService {
  final FirebaseFirestore database = FirebaseFirestore.instance;
  final String? uid = AuthService().currentUser?.uid;

  String userDatabaseLabel = "users";
  String quizSessionDatabaseLabel = "sessions";

  //Get User's Total Score
  Stream<int> get totalScoreStream {
    if (uid == null) return Stream.value(0);
    return database.collection(userDatabaseLabel).doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return (doc.data() as Map<String, dynamic>)['totalScore'] ?? 0;
      } else {
        return 0;
      }
    });
  }

  //Get a one-time snapshot of the current user's Firestore document.
  //Returns null if the user is not signed in, the document does not exist, or read fails.
  Future<Map<String, dynamic>?> getUserDocument() async {
    if (uid == null) return null;
    try {
      final doc = await database.collection(userDatabaseLabel).doc(uid).get();
      if (!doc.exists) return null;
      return doc.data();
    } on Exception catch (e) {
      debugPrint("Failed to read user document: $e");
      return null;
    }
  }

  //Sync user profile info to Firestore on sign-in
  Future<void> syncUserProfile() async {
    if (uid == null) return;
    try {
      await database.collection(userDatabaseLabel).doc(uid).set({
        'displayName': UserData.userName,
        'email': UserData.userEmail,
        'photo': UserData.userImageUrl,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } on Exception catch (e) {
      debugPrint("Failed to sync user profile: $e");
    }
  }

  //Save Quiz Session
  Future<void> saveQuizSession({required int gainedScore, required int totalAttempt, required int totalCorrect, required String category}) async {
    if (uid == null) return;
    final userRef = database.collection(userDatabaseLabel).doc(uid);
    final sessionRef = userRef.collection(quizSessionDatabaseLabel).doc();
    await database.runTransaction((transaction) async {
      // 1. Get current total score
      DocumentSnapshot userDoc = await transaction.get(userRef);
      int existingCurrentScore = 0;
      int newCurrentScore = 0;
      if (userDoc.exists) {
        existingCurrentScore = (userDoc.data() as Map<String, dynamic>)['totalScore'] ?? 0;
      }
      newCurrentScore = existingCurrentScore + gainedScore;
      // 2. Update user's total score
      transaction.set(userRef, {
        'totalScore': newCurrentScore,
        'displayName': UserData.userName,
        'email': UserData.userEmail,
        'photo': UserData.userImageUrl,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      // 3. Append session data
      transaction.set(sessionRef, {
        'quizCategory': category,
        'dateTime': FieldValue.serverTimestamp(),
        'totalAttempt': totalAttempt,
        'totalCorrect': totalCorrect,
        'gainedScore': gainedScore,
      });
    });
  }

  //Get user's session history
  Stream<QuerySnapshot> get sessionHistoryStream {
    if (uid == null) return Stream.empty();
    return database.collection(userDatabaseLabel).doc(uid).collection(quizSessionDatabaseLabel).orderBy('dateTime', descending: true).snapshots();
  }

  //Get all users info for leaderboard (ordered by totalScore)
  Stream<QuerySnapshot> get allUsersStream {
    return database.collection(userDatabaseLabel).orderBy('totalScore', descending: true).snapshots();
  }
}
