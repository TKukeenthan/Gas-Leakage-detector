import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'reusable_widget.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  late InputDecoration inputDecoration;
  String notify = '';
  bool passToggle = true;
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  late FirebaseAuth auth;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    inputDecoration = const InputDecoration(
        fillColor: Color.fromARGB(255, 215, 219, 221),
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.white, width: 2.0, style: BorderStyle.solid)),
        labelText: 'Username',
        labelStyle: TextStyle(color: Colors.red));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 36, 37, 37),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.08,
                    vertical: MediaQuery.of(context).size.height * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome\nBack!!!',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 201, 57, 177),
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    Column(
                      children: [
                        reusableTextField(
                          'Enter UserName',
                          Icons.person,
                          false,
                          _emailTextController,
                          keyboardType: TextInputType.emailAddress,
                          paddingVertical:
                              MediaQuery.of(context).size.height * 0.015,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        reusableTextField(
                          'Enter pasword',
                          Icons.lock,
                          true,
                          _passwordTextController,
                          keyboardType: TextInputType.visiblePassword,
                          paddingVertical:
                              MediaQuery.of(context).size.height * 0.015,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        signInSignUpButton(
                          context,
                          true,
                          () {
                            FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text)
                                .then((value) {
                              if (kDebugMode) {
                                Navigator.pushNamed(context, 'splashScreen');
                                setState(() {
                                  notify = 'success';
                                });
                                print("success");
                              }
                            }).onError((error, stackTrace) {
                              print(error.hashCode);
                              if (kDebugMode) {
                                setState(() {
                                  notify = error.toString();
                                });
                                print("Error ${error.toString()}");
                              }
                            });
                          },
                          text: 'Sign In',
                          paddingVertical:
                              MediaQuery.of(context).size.height * 0.02,
                        ),
                        Text(notify),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account? ',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 194, 90, 90),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, 'Register');
                              },
                              child: Text(
                                'Create an Account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, 'forgotpassword');
                              },
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
