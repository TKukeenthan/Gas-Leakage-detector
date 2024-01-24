// ignore_for_file: camel_case_types, unused_field

import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gldapplication/location/sample.dart';

class nearby extends StatefulWidget {
  const nearby({super.key});

  @override
  State<nearby> createState() => _nearbyState();
}

class _nearbyState extends State<nearby> {
  final geo = GeoFlutterFire();
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: UserLocations(),
    )));
  }
}
