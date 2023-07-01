import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:outdoor_admin/Trips/trip_details.dart';
import 'package:outdoor_admin/noe_box.dart';

class TripGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Grid'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('trips').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final trips = snapshot.data!.docs;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final tripData = trips[index].data() as Map<String, dynamic>;

              // Retrieve trip information
              final title = tripData['title'] as String;
              final location = tripData['location'] as String;
              final days = tripData['days'] as int;
              final description = tripData['description'] as String;
              final photoUrls =
                  List<String>.from(tripData['photoUrls'] as List<dynamic>);

              // Show the first photo in the grid
              final firstPhotoUrl = photoUrls.isNotEmpty ? photoUrls[0] : '';

              return GestureDetector(
                onTap: () {
                  // Navigate to trip details page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripDetails(
                        title: title,
                        location: location,
                        days: days,
                        description: description,
                        photoUrls: photoUrls,
                      ),
                    ),
                  );
                },
                child: GridTile(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NeoBox(
                      value: Stack(
                        children: [
                          firstPhotoUrl.isNotEmpty
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                                child: Image.network(firstPhotoUrl, fit: BoxFit.cover,width: double.infinity,
                            height: 250,),
                              )
                              : Placeholder(),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: 300,
                                height: 40,
                                alignment: Alignment.center,

                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius:BorderRadius.only(
                                bottomLeft: Radius.circular(12.0),
                                bottomRight: Radius.circular(12.0),
                              ),
                                ),

                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              );
            },
          );
        },
      ),
    );
  }
}
