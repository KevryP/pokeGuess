import 'package:flutter/material.dart';

class SignupDialog extends StatefulWidget {
  final Function(String, String) signUpFunction;
  const SignupDialog({super.key, required this.signUpFunction});

  @override
  State<SignupDialog> createState() => _SignupDialogState();
}

class _SignupDialogState extends State<SignupDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: signupPage(),
    );
  }

  Scaffold signupPage() {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(
                      color: Colors.white,
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
                      "Create an account",
                      style: TextStyle(
                        fontFamily: 'Pokemon',
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  signUpForm()
                ]),
              ),
            ),
          ],
        ));
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
                    backgroundColor: const Color.fromARGB(255, 0, 183, 255)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //Successful
                    widget.signUpFunction(
                        _emailController.text, _passwordController.text);
                    Navigator.pop(context);
                  }
                  return;
                },
                child: const Text("Create account"),
              ),
            ),
          ],
        ));
  }
}
