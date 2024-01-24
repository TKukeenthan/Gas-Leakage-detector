// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:gldapplication/leaky.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'ChatBot/chatBotScreen.dart';
import 'chat app/HomeScreen.dart';

import 'location/practice.dart';
import 'profile/menu.dart';
import 'provider/gas_leaky_provider.dart';
import 'widgets/show_alert.dart';

class navbar extends StatefulWidget {
  const navbar({Key? key}) : super(key: key);

  @override
  State<navbar> createState() => _navbarState();
}

class _navbarState extends State<navbar> {
  int selectedIndex = 0;
  final fs = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late Map<String, dynamic> userData = {};

  final _screens = [
    const leaky(),
    const HomeScreen(),
    const nearby(),
    const ChatBotScreen()
  ];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;

        // Get user data from Firestore
        final userDoc =
            await fs.collection('users').doc(loggedInUser.email).get();
        userData = userDoc.data() ?? {};

        // Get additional data from other collections
        final otherData = await Future.wait([
          fs.collection('collection1').doc(loggedInUser.email).get(),
          fs.collection('collection2').doc(loggedInUser.email).get(),
          // Add more collections as needed
        ]);

        for (final doc in otherData) {
          userData.addAll(doc.data() ?? {});
        }

        setState(() {});
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GasLeakProvider>(builder: (context, provider, _) {
      if (provider.gasValue == 1) {
        //   // Gas leak detected, show the alert dialog
        showGasLeakageAlert(context);
      }
      final Size size = MediaQuery.of(context).size;
      return SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 36, 37, 37),
          appBar: AppBar(
            title: Center(
              child: Text(
                getTitle(selectedIndex),
                style:
                    const TextStyle(color: Color.fromARGB(255, 248, 245, 248)),
              ),
            ),
            iconTheme: const IconThemeData(
              color: Colors.white, // Set the color of the hamburger icon here
            ),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'NotificationScreen');
                },
                icon: const Icon(Icons.notifications),
              ),
            ],
          ),
          drawer: const ProfileMenu(),
          body: _screens[selectedIndex],
          bottomNavigationBar: SizedBox(
            height: size.height * 0.08,
            child: BottomNavigationBar(
              backgroundColor: const Color.fromARGB(255, 36, 37, 37),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.purple,
              unselectedItemColor: Colors.white,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              currentIndex: selectedIndex,
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.chat_bubble_text_fill),
                  label: "Message",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_on),
                  label: "Location",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.api_sharp),
                  label: "ChatBot",
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  String getTitle(int index) {
    switch (index) {
      case 0:
        return "Home";
      case 1:
        return "Message";
      case 2:
        return "Location Tracker";
      case 3:
        return "ChatBot";
      default:
        return "My App";
    }
  }

  void showGasLeakageAlert(BuildContext context) {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (context) {
          return GasLeakageAlert();
        },
      );
    });
  }
}
