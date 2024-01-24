import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../api.dart';
import '../chatUser.dart';
import '../widgets/show_alert.dart';

class GasLeakProvider extends ChangeNotifier {
  final databaseReference = FirebaseDatabase.instance.reference();

  late ChatUser chatuser;

  int seconds = 0, minutes = 0, hours = 0;
  String digitSeconds = "00", digitMinutes = "00", digitHours = "00";
  double gasValue = 0.0;
  bool _isLeakageStarted = false;
  bool get isLeakageStarted => _isLeakageStarted;
  late DateTime leakageStartTime = DateTime.now();
  bool _isTimerStarted = false;
  bool get isTimerStarted => _isTimerStarted;
  Timer? timer;
  GasLeakProvider(BuildContext context) {
    fetchData(context); // Call fetchData to initialize the gas value
  }

  void fetchData(BuildContext context) {
    databaseReference.child('Gas Value').onValue.listen((event) {
      if (event.snapshot.value != null) {
        gasValue = (event.snapshot.value as num).toDouble();
        if (gasValue == 1) {
          _isLeakageStarted = true;

          start();
          APIs.sendPushNotificationGasLeakage();
          //showGasLeakageAlert(context);
          notifyListeners();

          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (_) => const navbar()));
          // notifyListeners();

          // APIs.sendPushNotificationGasLeakage(ChatUser as ChatUser);
        } else {
          _isLeakageStarted = false;
          stop();
          notifyListeners();
        }
        notifyListeners();
      }
      notifyListeners();
    });
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

  void stop() {
    timer?.cancel();
    _isTimerStarted = false;
    notifyListeners();
  }

  void reset() {
    timer!.cancel();
    seconds = 0;
    minutes = 0;
    hours = 0;
    digitSeconds = "00";
    digitMinutes = "00";
    digitHours = "00";
    _isTimerStarted = false;
    notifyListeners();
  }

  void start() {
    _isTimerStarted = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int localSeconds = seconds + 1;
      int localMinutes = minutes;
      int localHours = hours;

      if (localSeconds > 59) {
        if (localMinutes > 59) {
          localHours++;
          localMinutes = 0;
        } else {
          localMinutes++;
          localSeconds = 0;
        }
      }
      seconds = localSeconds;
      minutes = localMinutes;
      hours = localHours;
      digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
      digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
      digitHours = (hours >= 10) ? "$hours" : "0$hours";
      notifyListeners();
    });
  }
}
