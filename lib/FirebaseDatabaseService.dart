import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseDatabaseService extends ChangeNotifier {
  late FirebaseFirestore _db;
  late CollectionReference usersRef;
  FirebaseDatabaseService() {
    _db = FirebaseFirestore.instance;
    usersRef = _db.collection('users');
  }

  Future<void> addUser(email) async {
    User? user = FirebaseAuth.instance.currentUser;

    return usersRef.doc(user?.uid).set({
      'email': email,
      'catches': 0,
      'currentStreak': 0,
      'longestStreak': 0,
    }).catchError((error) {
      print("Error adding to DB: $error");
    });
  }

  Future<bool> addCaughtPoke(pokeName) async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      await usersRef.doc(user?.uid).collection('caught').doc(pokeName).set({
        'name': pokeName,
      });
      await usersRef.doc(user?.uid).update({
        'lastCatch': DateTime.now(),
        'catches': FieldValue.increment(1),
      });
      updateStreak('win');
      notifyListeners();
      return true;
    } catch (e) {
      print("Error adding to DB: $e");
      return false;
    }
  }

  Future<DocumentSnapshot> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    return await usersRef.doc(user?.uid).get();
  }

  Future<int> getNumCaught() async {
    User? user = FirebaseAuth.instance.currentUser;
    AggregateQuerySnapshot qSnapshot =
        await usersRef.doc(user?.uid).collection('caught').count().get();

    return qSnapshot.count;
  }

  Future<int> getCurrentStreak() async {
    DocumentSnapshot documentSnapshot = await getUserData();
    return documentSnapshot['currentStreak'];
  }

  Future<int> getLongestStreak() async {
    DocumentSnapshot documentSnapshot = await getUserData();
    return documentSnapshot['longestStreak'];
  }

  Future<bool> updateStreak(String result) async {
    User? user = FirebaseAuth.instance.currentUser;
    int cStreak = await getCurrentStreak();
    int lStreak = await getLongestStreak();
    if (result == 'loss') {
      await usersRef.doc(user?.uid).update({
        'currentStreak': 0,
      });
      return false;
    } else {
      await usersRef.doc(user?.uid).update({
        'currentStreak': cStreak + 1,
      });
      cStreak++;
      if (cStreak > lStreak) {
        await usersRef.doc(user?.uid).update({
          'longestStreak': cStreak,
        });
        notifyListeners();

        return true;
      }
    }

    return false;
  }
}
