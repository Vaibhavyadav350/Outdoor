import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayItineraryDetails extends StatefulWidget {
  final String groupLeadContact;

  DisplayItineraryDetails({required this.groupLeadContact});

  @override
  _DisplayItineraryDetailsState createState() =>
      _DisplayItineraryDetailsState();
}

class _DisplayItineraryDetailsState extends State<DisplayItineraryDetails> {
  DocumentSnapshot? itineraryDoc;

  @override
  void initState() {
    super.initState();
    fetchItineraryDetails();
  }

  Future<void> fetchItineraryDetails() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('Itineraries')
          .where('groupLeadContact', isEqualTo: widget.groupLeadContact)
          .get();

      if (doc.docs.isNotEmpty) {
        setState(() {
          itineraryDoc = doc.docs.first;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentTripDate = DateTime.fromMillisecondsSinceEpoch(
        itineraryDoc!['initialDateofTrip'].seconds * 1000);
    return Scaffold(
      appBar: AppBar(
        title: Text("Itinerary Details"),
      ),
      body: (itineraryDoc == null)
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(20),
              children: [
                ListTile(
                  title: Text("PAX"),
                  subtitle: Text(itineraryDoc!['pax']),
                ),
                ListTile(
                  title: Text("Traveller ID"),
                  subtitle: Text(itineraryDoc!['travellerid']),
                ),
                ListTile(
                  title: Text("Group Lead Name"),
                  subtitle: Text(itineraryDoc!['groupLeadname']),
                ),
                ListTile(
                  title: Text("Initial Date of Trip"),
                  subtitle:
                      Text("${itineraryDoc!['initialDateofTrip'].toDate()}"),
                ),
                ListTile(
                  title: Text("Final Date of Trip"),
                  subtitle:
                      Text("${itineraryDoc!['finalDateofTrip'].toDate()}"),
                ),
                ListTile(
                  title: Text("Locations with Dates"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(itineraryDoc!['locations'].length, (index) {
                      String locationName = itineraryDoc!['locations'][index]['name'] ?? "N/A"; // Access 'name'
                      String locationPhone = itineraryDoc!['locations'][index]['phone'] ?? "N/A"; // Access 'phone'
                      String locationLicense = itineraryDoc!['locations'][index]['license'] ?? "N/A"; // Access 'license'

                      String locationDate = "${currentTripDate.day}-${currentTripDate.month}-${currentTripDate.year}";
                      currentTripDate = currentTripDate.add(Duration(days: 1));

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("$locationName on $locationDate"),
                          Text("Phone: $locationPhone"),
                          Text("License: $locationLicense"),
                          SizedBox(height: 8) // For spacing between location details
                        ],
                      );
                    }),
                  ),
                ),


                ListTile(
                  title: Text("Driver Details"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        itineraryDoc!['driversDetails'].length, (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Name: ${itineraryDoc!['driversDetails'][index]['name']}"),
                          Text(
                              "License: ${itineraryDoc!['driversDetails'][index]['license']}"),
                          Text(
                              "Phone: ${itineraryDoc!['driversDetails'][index]['phone']}"),
                          SizedBox(
                              height: 8), // For spacing between driver details
                        ],
                      );
                    }),
                  ),
                ),
                ListTile(
                  title: Text("Vendor"),
                  subtitle: Text(itineraryDoc!['vendor']),
                ),
                // Add more ListTiles for other fields as required
              ],
            ),
    );
  }
}
