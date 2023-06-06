import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:outdoor_admin/noe_box.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'trid.dart';

import '../../theme/colors.dart';

class TravellerScreen extends StatefulWidget {
  late String value;

  TravellerScreen({required this.value});

  @override
  _TravellerScreenState createState() => _TravellerScreenState(value);
}

class _TravellerScreenState extends State<TravellerScreen> {
  String value;

  _TravellerScreenState(this.value);

  String pluscode = '';
  late TextEditingController _collectionNameController =
      TextEditingController();

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _documents = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _vendordocuments = [];

  @override
  void initState() {
    super.initState();
    _fetchData(); // Call fetchData function when the screen is initialized
  }

  @override
  void dispose() {
    _collectionNameController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    // Fetch data from Firestore
    _collectionNameController.text = value;
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Spiti')
        .doc('Users')
        .collection('Users')
        .doc(_collectionNameController.text)
        .collection(_collectionNameController.text)
        .get();
    // Sort documents based on selectedDate
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sortedDocuments =
        snapshot.docs.toList()
          ..sort((a, b) =>
              a.data()['selectedDate'].compareTo(b.data()['selectedDate']));

    setState(() {
      _documents = sortedDocuments;
    });

    QuerySnapshot<Map<String, dynamic>> snapshots = await FirebaseFirestore
        .instance
        .collection('Spiti')
        .doc('Users')
        .collection('Users')
        .doc(_collectionNameController.text)
        .collection('vendor')
        .get();
    setState(() {
      _vendordocuments = snapshots.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("Your Trips"),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: [
            Image.asset(
              "assets/images/journey.jpg",
              fit: BoxFit.cover,
              height: 200,
            ),
            SizedBox(height: 16.0),
            // ElevatedButton(
            //   onPressed: _fetchData,
            //   child: Text('Show My Itinerary'),
            // ),
            SizedBox(height: 16.0),
            if (_documents.isEmpty)
              Center(child: Text('No data found'))
            else
              Column(
                children: _documents.map((doc) {
                  Map<String, dynamic> data = doc.data();
                  if (data['pluscode'] != null) {
                    String pluscode = data['pluscode'];
                  }

                  Timestamp timestamp = data['selectedDate'];
                  DateTime dateTime = timestamp.toDate();
                  String formattedDate =
                      DateFormat('dd-MM-yyyy').format(dateTime);
                  bool isFutureDate = dateTime.isBefore(DateTime.now());
                  return Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: SizedBox(
                      height: 60,
                      width: 350,
                      child: NeoBox(
                        value: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (data['pluscode'] != null) {
                                      String? pluscode = data['pluscode'];
                                      if (pluscode != null) {
                                        final encodedPlusCode =
                                            Uri.encodeComponent(pluscode);
                                        final googleMapsUrl =
                                            'https://maps.google.com/?q=$encodedPlusCode';
                                        if (await canLaunch(googleMapsUrl)) {
                                          await launch(googleMapsUrl);
                                        }
                                      }
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            title: Text('Error'),
                                            content:
                                                Text('No pluscode available.'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Close'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: Icon(Icons.location_on,
                                      color: Colors.redAccent),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                          Text(
                                            data['dropdownValue'],
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                        Text(
                                          'Date: $formattedDate',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: isFutureDate
                                          ? Icon(Icons.check,
                                              color: Colors.green)
                                          : null,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),

                        // title: Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //
                        //   ],
                        // ),
                        // subtitle:
                        // trailing:
                      ),
                    ),
                  );
                }).toList(),
              ),
            SizedBox(
              height: 10,
            ),
            if (_vendordocuments.isNotEmpty)
              Column(
                children: _vendordocuments.map((vdoc) {
                  Map<String, dynamic> vdata = vdoc.data();

                  if (vdata['vendor'] != null &&
                      vdata['vendor']['Driver'] != null) {
                    String driver = vdata['vendor']['Driver'];
                    String drivingLicense = vdata['vendor']['DriverLicense'];
                    String driverphone = vdata['vendor']['DriverPhone'];
                    return  Container(
                      margin: EdgeInsets.only(bottom: 16.0),
                      child: SizedBox(
                        height: 80,

                        width: 350,
                        child: NeoBox(
                            // leading:
                            value: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.deepPurple,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Driver: $driver",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20
                                          ),
                                        ),
                                        Text(
                                          "License: $drivingLicense",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700]
                                          ),
                                        ),
                                        Text(
                                          "Number: $driverphone",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                              color: Colors.grey[700]
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          String phoneNumber = driverphone.replaceAll(
                                              RegExp(r'[^0-9]'),
                                              ''); // Remove non-numeric characters from the phone number
                                          String telUrl =
                                              'tel:$phoneNumber'; // Construct the tel URL
                                          launch(telUrl); // Launch the phone call
                                        },
                                        child: Icon(
                                          Icons.phone,
                                          color: Colors.blue,
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),

                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }).toList(),
              ),
            if (_vendordocuments.isNotEmpty)
              Column(
                children: _vendordocuments.map((vdoc) {
                  Map<String, dynamic> vdata = vdoc.data();

                  if (vdata['vendor'] != null &&
                      vdata['vendor']['Car'] != null) {
                    String car = vdata['vendor']['Car'];
                    String carNumber = vdata['vendor']['CarNumber'];

                    return Container(
                      margin: EdgeInsets.only(bottom: 16.0),
                      child: SizedBox(
                        height: 60,
                        width: 350,
                        child: NeoBox(
                          value: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(

                                children: [
                                  Icon(
                                    Icons.directions_car_filled_sharp,
                                    color: Colors.deepPurple,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Car: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[700],
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "$car",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Car Number: ",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.w500
                                                // color: Colors.grey.shade700,
                                                ),
                                          ),
                                          Text(
                                            "$carNumber",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // subtitle:
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
