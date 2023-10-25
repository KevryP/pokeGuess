import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poke_guess/login.dart';
import 'package:poke_guess/widgets/game_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: signUpForm());
  }

  Form signUpForm() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email address",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter a password that meets the requirements';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  //Successful
                  _register();
                }
                return;
              },
              child: const Text("Sign Up"),
            ),
            Column(
              children: [
                const Text("Already have an account?"),
                ElevatedButton(
                  onPressed: () {
                    //Change to SignUp Page
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: const Text("Login"),
                ),
              ],
            )
          ],
        ));
  }

  _register() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((value) => _addUser())
          .then((value) => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const GuessGame())));
    } catch (e) {
      print("Signup error: $e");
    }
  }

  Future<void> _addUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    return users.doc(user?.uid).set({
      'email': _emailController.text,
    }).catchError((error) {
      print("Error adding to DB: $error");
    });
  }
}
