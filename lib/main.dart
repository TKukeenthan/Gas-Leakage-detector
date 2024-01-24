// ignore_for_file: camel_case_types, equal_keys_in_map, non_constant_identifier_names, unused_local_variable, must_be_immutable, prefer_typing_uninitialized_variables, deprecated_member_use

import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';

import 'package:gldapplication/splashmain.dart';
import 'package:provider/provider.dart';

import 'ChatBot/chatBotScreen.dart';

import 'Welcomescreen.dart';
import 'auth/forgotpassword.dart';
import 'auth/login.dart';
import 'auth/mapScreen.dart';
import 'auth/register.dart';
import 'auth/registerHome.dart';
import 'auth/resetpassword.dart';
import 'chat app/HomeScreen.dart';
import 'chat app/chat_card.dart';
import 'chat app/chatmessage.dart';
import 'chat app/splash.dart';
import 'chatUser.dart';
import 'firebaseoptions.dart';
import 'leaky.dart';
import 'location/practice.dart';
import 'location/splashmap.dart';
import 'navbar.dart';
import 'notification.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'provider/gas_leaky_provider.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  auth = FirebaseAuth.instanceFor(app: app);
  print(auth.languageCode);
  print('app successfully connected with firbase ${app.options}');

  //enter full-screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  //for setting orientation to portrait only
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    _initializeFirebase();
    _initializeFirebase_gas();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<GasLeakProvider>(
            create: (context) => GasLeakProvider(context),
          ),
        ],
        child: gldapp(),
      ),
    );
  });
}

class gldapp extends StatelessWidget {
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();

  gldapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      initialRoute: 'splashScreen',
      routes: {
        'splashScreen': (context) => const SplashScreen(),
        'Welcomescreen': (context) => const Welcomescreen(),
        'login': (context) => const MyLogin(),
        'Register': (context) => const Register(),
        'forgotpassword': (context) => ForgetPasswordPage(),
        'resetpassword': (context) => const ResetPassword(),
        'leaky': (context) => const leaky(),
        'navbar': (context) => const navbar(),
        'SplashScreenmain': (context) => const SplashScreenmain(),
        'nearby': (context) => const nearby(),
        'ChatBotScreen': (context) => const ChatBotScreen(),
        'SplashScreenmap': (context) => const SplashScreenmap(),
        'RegisterHomeLocation': (context) => const RegisterHomeLocation(),
        'MapScreen': (context) => const MapScreen(),
        'HomeScreen': (context) => const HomeScreen(),
        'ChatUserCard': (context) => ChatUserCard(
              user: ChatUser(
                  about: '',
                  address: {},
                  createdAt: '',
                  email: '',
                  id: '',
                  image: '',
                  isOnline: true,
                  lastActive: '',
                  mobile_number: '',
                  name: '',
                  pushToken: '',
                  home_location: {}),
            ),
        'chatmessage': (context) => chatmessage(
              email: '',
              onTapContact: (String email) {},
            ),
        'HomeScreen': (context) => const HomeScreen(),
        'NotificationScreen': (context) => NotificationScreen(
              user: ChatUser(
                  about: '',
                  address: {},
                  createdAt: '',
                  email: '',
                  id: '',
                  image: '',
                  isOnline: true,
                  lastActive: '',
                  mobile_number: '',
                  name: '',
                  pushToken: '',
                  home_location: {}),
            ),
      },
    );
  }
}

_initializeFirebase() async {
  var result = await FlutterNotificationChannel.registerNotificationChannel(
      description: 'For Showing Message Notification',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Chats');
  log('\nNotification Channel Result: $result');
}

_initializeFirebase_gas() async {
  var result1 = await FlutterNotificationChannel.registerNotificationChannel(
      description: 'For Showing Gas Leak stutas  Notification',
      id: 'gasLeakage',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'gasLeakage');
  log('\nNotification Channel Result: $result1');
}
