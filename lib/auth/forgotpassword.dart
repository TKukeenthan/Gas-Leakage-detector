// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, duplicate_ignore, unused_field, prefer_final_fields

import 'package:flutter/material.dart';

import 'reusable_widget.dart';

// ignore: use_key_in_widget_constructors
class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
        child: Scaffold(
            backgroundColor: Color.fromARGB(255, 36, 37, 37),
            body: Padding(
              // ignore: prefer_const_constructors
              padding: EdgeInsets.only(left: 35, top: 35),
              child: Column(
                  // ignore: duplicate_ignore
                  children: [
                    // ignore: prefer_const_constructors
                    Text('reset password',
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 33,
                        )),

                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.1,
                            right: 35,
                            left: 35),
                        child: Column(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            SizedBox(
                              height: 20.0,
                            ),
                            reusableTextField(
                                'Enter Email',
                                Icons.email_outlined,
                                false,
                                _emailTextController,
                                keyboardType: TextInputType.emailAddress,
                                paddingVertical:
                                    MediaQuery.of(context).size.height * 0.015),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    'reset password',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.arrow_forward,
                                          color: Colors.black),
                                    ),
                                  )
                                ]),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                fillColor: Color.fromARGB(255, 32, 28, 51),
                                filled: true,
                                hintText: 'Enret code',
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                        style: BorderStyle.none)),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    'Submit',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '''
resetpassword''');
                                      },
                                      icon: Icon(Icons.arrow_forward,
                                          color: Colors.black),
                                    ),
                                  )
                                ]),
                          ],
                        ),
                      ),
                    ),
                  ]),
            )));
  }

  BuildContext newMethod(BuildContext context) => context;
}
