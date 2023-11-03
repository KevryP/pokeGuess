import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poke_guess/signup.dart';
import 'package:poke_guess/widgets/game_page.dart';
import 'package:poke_guess/widgets/game_widget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.red,
                border: Border.all(
                  color: Colors.blueAccent,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                )),
            width: 300,
            height: 400,
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontFamily: 'Pokemon',
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              loginForm()
            ]),
          ),
        ),
      ],
    ));
  }

  Form loginForm() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email address",
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            const Padding(padding: EdgeInsets.all(10)),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
                filled: true,
                fillColor: Colors.white,
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter a password that meets the requirements';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 183, 255),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //Succesfful
                    onLogin();
                  }
                  return;
                },
                child: const Text("Login"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(30),
                          backgroundColor:
                              const Color.fromARGB(255, 0, 183, 255)),
                      onPressed: () {
                        //Change to SignUp Page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()));
                      },
                      child: const Text("SignUp"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  onLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Material(
              child: GamePage(),
            ),
          ));
    } catch (e) {
      print("Login error: $e");
    }
  }
}
