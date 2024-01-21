import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poke_guess/FireabseAuthService.dart';
import 'package:poke_guess/FirebaseDatabaseService.dart';
import 'package:poke_guess/login_dialog.dart';
import 'package:poke_guess/signup_dialog.dart';
import 'package:poke_guess/widgets/trainercard.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  //CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  final FirebaseAuthService authService = FirebaseAuthService();
  final FirebaseDatabaseService dbService = FirebaseDatabaseService();

  @override
  void initState() {
    super.initState();
  }

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        TrainerCard(user: user),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
          ],
        ),
      ]),
    );
  }

  void _signOut() {
    authService.signOut();
    setState(() {
      user = null;
    });
  }

  void _signIn(email, password) async {
    await authService.emailSignIn(email, password);
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
  }

  void _signUp(email, password) async {
    await authService.emailSignUp(email, password);
    //_addUserToDB(email);
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
  }

  /*Future<void> _addUserToDB(email) {
    User? user = FirebaseAuth.instance.currentUser;

    return usersRef.doc(user?.uid).set({
      'email': email,
    }).catchError((error) {
      print("Error adding to DB: $error");
    });
  }*/
}
