// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapsample extends StatelessWidget {
  final LatLng initialPosition;
  final String userName;

  const Mapsample({
    Key? key,
    required this.initialPosition,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
      ),
      drawer: Mapsample(initialPosition: initialPosition, userName: userName),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId(userName),
            position: initialPosition,
            infoWindow: InfoWindow(title: userName),
          ),
        },
      ),
    );
  }
}
