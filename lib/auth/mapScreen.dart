// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../chatUser.dart';
import '../navbar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late ChatUser user;
  LatLng? _homeLocation;

  void _onMapLongPress(LatLng latLng) {
    setState(() {
      _homeLocation = latLng;
    });
  }

  Future<void> _updateHomeLocation() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser!.uid)
          .update({
        'home_location.latitude': _homeLocation!.latitude,
        'home_location.longitude': _homeLocation!.longitude,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Home location updated successfully')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const navbar()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update home location')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true, // enable user's location
            onLongPress: _onMapLongPress,
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
            ),
            markers: _homeLocation == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId('home_location'),
                      position: _homeLocation!,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    ),
                  },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              child: const Text('Add Home Location'),
              onPressed: _homeLocation == null ? null : _updateHomeLocation,
            ),
          ),
        ],
      ),
    );
  }
}
