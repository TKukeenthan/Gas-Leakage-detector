import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:units_converter/units_converter.dart';

class NearbyLocation extends StatelessWidget {
  NearbyLocation({super.key});

  final geo = GeoFlutterFire();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // Create a geoFirePoint for your center location
    GeoFirePoint center =
        geo.point(latitude: 17.6187362, longitude: 77.9494144);

    // Get the collection reference
    var collectionReference = firestore.collection('locations');

    // Set the radius for nearby locations
    double radius = 10;

    // Set the field to 'position' assuming each document has a 'position' field of type GeoPoint
    String field = 'position';

    // Stream to get nearby locations
    Stream<List<DocumentSnapshot>> streamOfNearby = geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: field);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Documents'),
      ),
      body: SafeArea(
        child: StreamBuilder<List<DocumentSnapshot>>(
          stream: streamOfNearby,
          builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
            if (!snapshot.hasData) {
              return const Text('No data');
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                DocumentSnapshot data = snapshot.data![index];

                // Access the 'name' field from the document
                String locationName = data.get('name') ?? '';

                // Access the 'position' field from the document
                GeoPoint documentLocation =
                    data.get('position') ?? GeoPoint(0, 0);

                // Calculate distance between the center and document location
                double distanceInMeters = Geolocator.distanceBetween(
                  center.latitude,
                  center.longitude,
                  documentLocation.latitude,
                  documentLocation.longitude,
                );

                return ListTile(
                  title: Text(locationName),
                  subtitle: Text(
                    '${distanceInMeters.convertFromTo(LENGTH.meters, LENGTH.kilometers)!.toStringAsFixed(2)} KM',
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
