import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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

  late TextEditingController _collectionNameController = TextEditingController();

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
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('Spiti')
        .doc('Users')
        .collection('Users')
        .doc(_collectionNameController.text)
        .collection(_collectionNameController.text)
        .get();
    // Sort documents based on selectedDate
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sortedDocuments = snapshot.docs.toList()
      ..sort((a, b) => a.data()['selectedDate'].compareTo(b.data()['selectedDate']));

    setState(() {
      _documents = sortedDocuments;
    });

    QuerySnapshot<Map<String, dynamic>> snapshots = await FirebaseFirestore.instance
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Your Trips"),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                    Timestamp timestamp = data['selectedDate'];
                    DateTime dateTime = timestamp.toDate();
                    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
                    bool isFutureDate = dateTime.isBefore(DateTime.now());
                    return Container(
                      margin: EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.amberAccent,
                          width: 1.0,
                        ),

                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(20.0)
                        ),
                        color: Vx.amber50, // Green touch background color
                      ),
                      child: ListTile(
                        leading: Icon(Icons.house,color: Colors.deepPurple,),
                        title: Text(
                          data['dropdownValue'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Date: $formattedDate',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        trailing: isFutureDate ? Icon(Icons.check, color: Colors.green) : null,
                      ),
                    );
                  }).toList(),
                ),
              SizedBox(height: 10,),
              if (_vendordocuments.isNotEmpty)
                Column(
                  children: _vendordocuments.map((vdoc) {
                    Map<String, dynamic> vdata = vdoc.data();

                    if (vdata['vendor'] != null && vdata['vendor']['Driver'] != null) {
                      String driver = vdata['vendor']['Driver'];
                      String drivingLicense = vdata['vendor']['DriverLicense'];
                      String driverphone = vdata['vendor']['DriverPhone'];
                      return Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.amberAccent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40.0),
                              bottomLeft: Radius.circular(20.0)
                          ),
                          color: Vx.amber50,  // Green touch background color
                        ),
                        child: ListTile(
                          leading: Icon(Icons.person,color: Colors.deepPurple,),
                          title: Text(
                            "Driver: $driver",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5,),

                              Text(
                                "License: $drivingLicense",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                "PhoneNumber: $driverphone",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              String phoneNumber = driverphone.replaceAll(RegExp(r'[^0-9]'), ''); // Remove non-numeric characters from the phone number
                              String telUrl = 'tel:$phoneNumber'; // Construct the tel URL
                              launch(telUrl); // Launch the phone call
                            },
                            child: Icon(Icons.phone,color: Colors.blue,),
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

                    if (vdata['vendor'] != null && vdata['vendor']['Car'] != null) {
                      String car = vdata['vendor']['Car'];
                      String carNumber = vdata['vendor']['CarNumber'];

                      return Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.amberAccent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40.0),
                              bottomLeft: Radius.circular(20.0)
                          ),
                          color: Vx.amber50,  // Green touch background color
                        ),
                        child: ListTile(
                          leading: Icon(Icons.directions_car_filled_sharp,color: Colors.deepPurple,),
                          title: Text(
                            "Car: $car",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Car Number: $carNumber",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade700,
                            ),
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
      ),
    );
  }
}
