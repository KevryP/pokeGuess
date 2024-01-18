import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poke_guess/login_dialog.dart';
import 'package:poke_guess/signup_dialog.dart';
import 'package:poke_guess/widgets/trainercard.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
  }

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        Text(user != null ? user!.email! : "Unknown Trainer"),
        const TrainerCard(),
        (user == null)
            ? Row(children: [
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return LoginDialog(signInFunction: _signIn);
                          });
                    },
                    child: const Text("Log In")),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SignupDialog(signUpFunction: _signUp);
                          });
                    },
                    child: const Text("Sign Up")),
              ])
            : ElevatedButton(
                onPressed: () => _signOut(), child: const Text("Sign Out")),
      ]),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      user = null;
    });
  }

  Future<void> _signIn(email, password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      setState(() {
        user = FirebaseAuth.instance.currentUser;
      });
    } catch (e) {
      print("Login error: $e");
    }
  }

  Future<void> _signUp(email, password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      _addUserToDB(email);
      setState(() {
        user = FirebaseAuth.instance.currentUser;
      });
    } catch (e) {
      print("Login error: $e");
    }
  }

  Future<void> _addUserToDB(email) {
    User? user = FirebaseAuth.instance.currentUser;

    return usersRef.doc(user?.uid).set({
      'email': email,
    }).catchError((error) {
      print("Error adding to DB: $error");
    });
  }
}
