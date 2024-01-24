import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gldapplication/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../api.dart';

import 'auth/registerHome.dart';

//splash screen
class SplashScreenmain extends StatefulWidget {
  const SplashScreenmain({super.key});

  @override
  State<SplashScreenmain> createState() => _SplashScreenmainState();
}

class _SplashScreenmainState extends State<SplashScreenmain> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      //exit full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white));

      if (APIs.auth.currentUser != null) {
        log('\nUser: ${APIs.auth.currentUser}');
        //fetch user data from Firestore
        FirebaseFirestore.instance
            .collection('users')
            .doc(APIs.auth.currentUser!.uid)
            .get()
            .then((snapshot) {
          if (snapshot.exists) {
            //display user data in console
            log('\nUser Data: ${snapshot.data()}');
            if (snapshot.data()!['latitude'] == null) {
              //navigate to RegisterHome screen if home_location is empty
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const RegisterHomeLocation()));
            } else {
              //navigate to home screen
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const navbar()));
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 37, 37),
      //body
      body: Stack(children: [
        //app logo
        Positioned(
            top: MediaQuery.of(context).size.height * .15,
            right: MediaQuery.of(context).size.width * .25,
            width: MediaQuery.of(context).size.width * .5,
            child: Image.asset('images/home.png')),

        //google login button
        Positioned(
            bottom: MediaQuery.of(context).size.height * .15,
            width: MediaQuery.of(context).size.width,
            child: const Text('MADE IN SRILANKA WITH ❤️',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: Colors.black87, letterSpacing: .5))),
      ]),
    );
  }
}
