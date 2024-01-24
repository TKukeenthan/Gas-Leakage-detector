import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gldapplication/location/practice.dart';

import '../api.dart';
import '../auth/login.dart';

//splash screen
class SplashScreenmap extends StatefulWidget {
  const SplashScreenmap({super.key});

  @override
  State<SplashScreenmap> createState() => _SplashScreenmapState();
}

class _SplashScreenmapState extends State<SplashScreenmap> {
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
        //navigate to home screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const nearby()));
      } else {
        //navigate to login screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MyLogin()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)

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
