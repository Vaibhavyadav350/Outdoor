import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:outdoor_admin/page/Iteanary/collection.dart';
import 'package:outdoor_admin/page/Iteanary/pax.dart';
import 'package:outdoor_admin/page/Iteanary/selectcar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../routes.dart';
//import '../../services/auth.dart';

class Itenary extends StatefulWidget {
  late String pax;
  late String travellerid;
  late String groupLeadContact;
  Itenary({Key? key, required this.pax, required this.travellerid, required this.groupLeadContact}) : super(key: key);

  @override
  _ItenaryState createState() => _ItenaryState(pax, travellerid, groupLeadContact);
}

class _ItenaryState extends State<Itenary> {
  late String collectionName;
  late CollectionReference stayscollection;
  DateTime initialDate = DateTime.now();
  DateTime finaldate = DateTime.now();
  late int numDropdowns = 0;
  late int numDropdownsvendor =0;
  List<DateTime> dropdownDates = [];
  List<Map<String, dynamic>> dropdownValues = [];
  late CollectionReference dropdownsCollection;
  Map<int, dynamic> selectedValues = {};
  late CollectionReference userCollection;
  final _collectionNameController = TextEditingController();
  late TextEditingController phonenumbercontroller = TextEditingController();
  late CollectionReference vendorDropdownCollection;
  late DocumentReference driveDropdownCollection;
  late String selectedVendorValue = "Vaibhav";
  List<Map<String, dynamic>> selectedDriverValue = [];
  late String dropdownvalue = 'Vendor 1';

  String travellerid;
  String pax;
  String groupLeadContact;

  _ItenaryState( this.pax, this.travellerid,this.groupLeadContact);

  @override
  void initState() {
    super.initState();
    dropdownsCollection = FirebaseFirestore.instance.collection('Spiti').doc('Stays').collection('Stays');
    vendorDropdownCollection = FirebaseFirestore.instance.collection('Spiti').doc('Vendors').collection('vendors');
    userCollection = FirebaseFirestore.instance.collection('Spiti').doc('User').collection('Users');
  }


  void _generateDropdowns() {
    dropdownDates.clear();
    dropdownValues.clear();
    for (int i = 0; i < numDropdowns; i++) {
      dropdownDates.add(initialDate.add(Duration(days: i)));
      dropdownValues.add(
          {'dropdownValue': null, 'selectedDate': dropdownDates[i]});
    }
  }
  void _generateDropdownsforvendor() {
    dropdownDates.clear();
    dropdownValues.clear();
    for (int i = 0; i < numDropdownsvendor; i++) {
      dropdownDates.add(initialDate.add(Duration(days: i)));
      selectedDriverValue.add(
          {'Driver': null});
    }
  }

  // void _sendSMS(String message, List<String> recipents) async {
  //   String _result = await sendSMS(message: message, recipients: recipents)
  //       .catchError((onError) {
  //     print(onError);
  //   });
  //   print(_result);
  // }
  void sendWhatsAppMessage(String phoneNumber, String message) async {
    String url = "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  void _saveToFirestore() async {
    _collectionNameController.text = travellerid;
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('Spiti')
        .doc('Users')
        .collection('Users')
        .doc(_collectionNameController.text)
        .collection(_collectionNameController.text);
    CollectionReference collectionRefvendor = FirebaseFirestore.instance
        .collection('Spiti')
        .doc('Users')
        .collection('Users')
        .doc(_collectionNameController.text)
        .collection('vendor');
    FirebaseFirestore.instance
        .collection('Spiti')
        .doc('Users')
        .collection('Users')
        .doc(_collectionNameController.text)
        .set({
      'optionValue': _collectionNameController.text,
      'timestamp': finaldate,
      'GroupContact': groupLeadContact
    });

    for (int i = 0; i < numDropdowns; i++) {
      await collectionRef.add(dropdownValues[i]);
    }

    for (int i = 0; i < numDropdownsvendor; i++) {
      await collectionRefvendor.add({
        'vendor': selectedDriverValue[i],
        'timestamp': DateTime.now(),
      });
    }

    for (int i = 0; i < numDropdownsvendor; i++) {
      List<Map<String, dynamic>> dropdownStayArray = [];

      for (int j = 0; j < numDropdowns; j++) {
        Map<String, dynamic> dropdownValueMap = {
          'pax': pax,
          'selectedDate': dropdownValues[j]['selectedDate'],
          'dropdownValue': dropdownValues[j]['dropdownValue'],
          'groupLeadContact': groupLeadContact,
        };
        dropdownStayArray.add(dropdownValueMap);
      }

      await FirebaseFirestore.instance
          .collection('Spiti')
          .doc('DriverInfo')
          .collection('DriverInfo')
          .doc(selectedDriverValue[i]['Driver'])
          .update({'Driver': FieldValue.arrayUnion(dropdownStayArray)});
    }

    for (int i = 0; i < numDropdowns; i++) {
      List<Map<String, dynamic>> dropdownStayArray = [];

      for (int j = 0; j < numDropdownsvendor; j++) {
        Map<String, dynamic> dropdownValueMap = {
          'pax': pax,
          'selectedDate': dropdownValues[i]['selectedDate'],
          'groupLeadContact': groupLeadContact,
        };
        dropdownStayArray.add(dropdownValueMap);
      }

      await FirebaseFirestore.instance
          .collection('Spiti')
          .doc('StaysInfo')
          .collection('StaysInfo')
          .doc(dropdownValues[i]['dropdownValue'])
          .update({'dropdownValue': FieldValue.arrayUnion(dropdownStayArray)});
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Save Car Information>>'),
    ));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SelectCar(
          travellerid: travellerid,
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Create Itinery'),
      ),

      drawer: Drawer(

        child: ListView(

          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amberAccent,
              ),
              child: Column(
                children: [
                  // Image.network(FirebaseAuth.instance.currentUser!.photoURL!,height: 100,width: 1000,),
                  // SizedBox(height: 15,),
                  // Text(FirebaseAuth.instance.currentUser!.displayName!),


                ],
              ),
            ),

            ListTile(
              leading: Icon(Icons.home,color: Colors.redAccent,),
              title: const Text('Add Stays'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pushNamed(context,MyRoutes.addStays);

              },
            ),
            ListTile(
              leading: Icon(Icons.drive_eta_rounded,color: Colors.redAccent,),
              title: const Text('Add Vendors'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pushNamed(context,MyRoutes.vendors);
              },
            ),
            ListTile(
              leading: Icon(Icons.people,color: Colors.redAccent,),
              title: const Text('Travellers'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pushNamed(context,MyRoutes.travellers);
              },
            ),
            ListTile(
              leading: Icon(Icons.done_all,color: Colors.redAccent,),
              title: const Text('All Itenary'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => Collections()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 10),

                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      numDropdowns = int.parse(value);
                      _generateDropdowns();
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter number of Days',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      numDropdownsvendor = int.parse(value);
                      _generateDropdownsforvendor();
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter number of Drivers',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 10),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 10),
              Text('Initial Date: '),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      initialDate = pickedDate;
                      _generateDropdowns();
                    });
                  }
                },
                child: Text(
                  '${initialDate.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontSize: 16,color: Colors.green),
                ),
              ),
              SizedBox(width: 10),
              Text('Final Date: '),

              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: finaldate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      finaldate = pickedDate;
                      _generateDropdowns();
                    });
                  }
                },
                child: Text(
                  '${finaldate.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontSize: 16,color: Colors.green),
                ),
              ),
            ],
          ),




          StreamBuilder<QuerySnapshot>(
            stream: vendorDropdownCollection.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading...');
              }
              return DropdownButton<String>(

                //  String vendordropdownValue = selectedVendorValue[document.id] ?? '';
                value: selectedVendorValue,
                items: snapshot.data!.docs.map((DocumentSnapshot document) {
                  return DropdownMenuItem<String>(
                    value: document.id,
                    child: Text(document.id),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedVendorValue= newValue!;
                  });
                },
              );
            },
          ),




          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: dropdownsCollection.get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return ListView.builder(
                  itemCount: numDropdowns,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Text('Day ${index + 1} '),
                      trailing:
                      DropdownButton(
                        value: dropdownValues[index]['dropdownValue'],
                        items: snapshot.data!.docs.map((
                            DocumentSnapshot document) {
                          return DropdownMenuItem(
                            value: document.get('name'),
                            child: Text(document.get('name')),
                          );
                        }).toList(),
                          onChanged: (value) async {
                            setState(() {
                              dropdownValues[index]['dropdownValue'] = value;
                              dropdownValues[index]['selectedDate'] = dropdownDates[index];
                            });

                            QuerySnapshot querySnapshot = await dropdownsCollection
                                .where('name', isEqualTo: value)
                                .get();

                            if (querySnapshot.docs.isNotEmpty) {
                              setState(() {
                                dropdownValues[index]['Location'] = querySnapshot.docs[0]['location'];
                                dropdownValues[index]['pluscode'] = querySnapshot.docs[0]['pluscode'];
                              });
                            }
                          },

                      ),


                    );
                  },
                );
              },
            ),
          ),


          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: vendorDropdownCollection.doc(selectedVendorValue).collection(selectedVendorValue).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return ListView.builder(
                  itemCount: numDropdownsvendor,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text('Driver ${index + 1}'),
                      trailing:
                      DropdownButton(
                        value: selectedDriverValue[index]['Driver'],
                        items: snapshot.data!.docs.map((
                            DocumentSnapshot document) {
                          return DropdownMenuItem(
                            value: document.get('drivername'),
                            child: Text(document.get('drivername')),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() async {
                            selectedDriverValue[index]['Driver'] = value;
                            QuerySnapshot querySnapshot = await vendorDropdownCollection
                                .doc(selectedVendorValue)
                                .collection(selectedVendorValue)
                                .where('drivername', isEqualTo: value)
                                .get();
                            if (querySnapshot.docs.isNotEmpty) {
                              setState(() {
                                selectedDriverValue[index]['DriverLicense']
                                = querySnapshot.docs[0]['driverLicense'];
                                selectedDriverValue[index]['DriverPhone']
                                = querySnapshot.docs[0]['driverphone'];
                              });
                            }

                            //   dropdownValues[index]['selectedDate'] = dropdownDates[index];
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),




          Container(

            width: 130,
            child: ElevatedButton(
              onPressed: () {
                _saveToFirestore();
                //  Navigator.pushNamed(context, routeName)
              },
              child: Row(

                children: [
                  Text('Proceed'),
                  Icon(Icons.arrow_forward_ios,color: Colors.grey,)
                ],),
            ),
          ),
        ],
      ),
    );
  }
}