// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocations extends StatelessWidget {
  const UserLocations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 37, 37),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<QueryDocumentSnapshot> usersSnapshot = snapshot.data!.docs;

          if (usersSnapshot.isEmpty) {
            return const Center(
              child: Text('No users found'),
            );
          }

          return ListView.builder(
            itemCount: usersSnapshot.length,
            itemBuilder: (context, index) {
              var userSnapshot = usersSnapshot[index];
              String userName = userSnapshot.get('name');
              var homeLocation = userSnapshot.get('home_location');
              if (homeLocation is Map<String, dynamic>) {
                GeoPoint geoPoint = GeoPoint(
                    homeLocation['latitude'], homeLocation['longitude']);
                LatLng latLng = LatLng(geoPoint.latitude, geoPoint.longitude);
                return ListTile(
                  title: Text(
                    userName,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Latitude: ${latLng.latitude}, Longitude: ${latLng.longitude}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 200,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: latLng,
                            zoom: 16,
                          ),
                          mapType: MapType.satellite,
                          markers: {
                            Marker(
                              markerId: MarkerId(userName),
                              position: latLng,
                            ),
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return ListTile(
                  title: Text(userName),
                  subtitle: const Text('Home location not set'),
                );
              }
            },
          );
        },
      ),
    );
  }
}
