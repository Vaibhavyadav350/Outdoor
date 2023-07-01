import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:outdoor_admin/noe_box.dart';

// import 'package:flutter_sms/flutter_sms.dart';
import 'package:outdoor_admin/page/Iteanary/MainPage/collection.dart';
import 'package:outdoor_admin/page/Iteanary/pax.dart';
import 'package:outdoor_admin/page/Iteanary/selectcar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../routes.dart';
//import '../../services/auth.dart';

class Itenary extends StatefulWidget {
  late String pax;
  late String travellerid;
  late String groupLeadContact;
  late String groupLeadname;

  Itenary(
      {Key? key,
      required this.pax,
      required this.travellerid,
      required this.groupLeadContact,
      required this.groupLeadname
      })
      : super(key: key);

  @override
  _ItenaryState createState() =>
      _ItenaryState(pax, travellerid, groupLeadContact,groupLeadname);
}

class _ItenaryState extends State<Itenary> {
  late String collectionName;
  late CollectionReference stayscollection;
  DateTime initialDate = DateTime.now();
  DateTime finaldate = DateTime.now();
  late int numDropdowns = 0;
  late int numDropdownsvendor = 0;
  List<DateTime> dropdownDates = [];
  List<Map<String, dynamic>> dropdownValues = [];
  late CollectionReference dropdownsCollection;
  Map<int, dynamic> selectedValues = {};
  late CollectionReference userCollection;
  final _collectionNameController = TextEditingController();
  late TextEditingController phonenumbercontroller = TextEditingController();
  late CollectionReference vendorDropdownCollection;
  late DocumentReference driveDropdownCollection;
  late String selectedVendorValue = "Select Vendor";
  List<Map<String, dynamic>> selectedDriverValue = [];
  late String dropdownvalue = 'Vendor 1';
  late String? fetchedFieldName; // Variable to store the fetched field name

  String travellerid;
  String pax;
  String groupLeadContact;
  String groupLeadname;

  _ItenaryState(this.pax, this.travellerid, this.groupLeadContact,this.groupLeadname);

  @override
  void initState() {
    super.initState();
    fetchComapnyname().then((_) {
      dropdownsCollection = FirebaseFirestore.instance
          .collection(fetchedFieldName!)
          .doc('Stays')
          .collection('Stays');
      vendorDropdownCollection = FirebaseFirestore.instance
          .collection(fetchedFieldName!)
          .doc('Vendors')
          .collection('vendors');
      userCollection = FirebaseFirestore.instance
          .collection(fetchedFieldName!)
          .doc('User')
          .collection('Users');
    });
  }

  Future<void> fetchComapnyname() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        String? phone = snapshot.data()?['phone'] as String?;
        if (phone != null) {
          QuerySnapshot<Map<String, dynamic>> querySnapshot =
              await FirebaseFirestore.instance.collection('number').get();

          if (querySnapshot.docs.isNotEmpty) {
            for (QueryDocumentSnapshot<Map<String, dynamic>> document
                in querySnapshot.docs) {
              List<dynamic> phoneArray = document.data()['phone'];
              for (int i = 0; i < phoneArray.length; i++) {
                if (phoneArray[i] is Map<String, dynamic>) {
                  Map<String, dynamic> map =
                      Map<String, dynamic>.from(phoneArray[i]);
                  if (map.containsValue(phone)) {
                    fetchedFieldName = map.keys.first;
                    break;
                  }
                } else if (phoneArray[i] == phone) {
                  fetchedFieldName = 'phone';
                  break;
                }
              }
            }
          }
        }
      }
    }
  }

  void _generateDropdowns() {
    numDropdowns = finaldate.difference(initialDate).inDays;
    dropdownDates.clear();
    dropdownValues.clear();
    for (int i = 0; i < numDropdowns; i++) {
      dropdownDates.add(initialDate.add(Duration(days: i)));
      dropdownValues
          .add({'dropdownValue': null, 'selectedDate': dropdownDates[i]});
    }
  }

  void _generateDropdownsforvendor() {
    dropdownDates.clear();
    dropdownValues.clear();
    for (int i = 0; i < numDropdownsvendor; i++) {
      dropdownDates.add(initialDate.add(Duration(days: i)));
      selectedDriverValue.add({'Driver': null});
    }
  }

  void sendWhatsAppMessage(String phoneNumber, String message) async {
    String url =
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _saveToFirestore() async {
    numDropdowns = finaldate.difference(initialDate).inDays;
    _collectionNameController.text = travellerid;
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection(fetchedFieldName!)
        .doc('Users')
        .collection('Users')
        .doc(_collectionNameController.text)
        .collection(_collectionNameController.text);
    CollectionReference collectionRefvendor = FirebaseFirestore.instance
        .collection(fetchedFieldName!)
        .doc('Users')
        .collection('Users')
        .doc(_collectionNameController.text)
        .collection('vendor');
    FirebaseFirestore.instance
        .collection(fetchedFieldName!)
        .doc('Users')
        .collection('Users')
        .doc(_collectionNameController.text)
        .set({
      'optionValue': _collectionNameController.text,
      'timestamp': finaldate,
      'GroupContact': groupLeadContact,
      'name':groupLeadname
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
          'groupLeadname':groupLeadname
        };
        dropdownStayArray.add(dropdownValueMap);
      }

      await FirebaseFirestore.instance
          .collection(fetchedFieldName!)
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
          'groupLeadname':groupLeadname
        };
        dropdownStayArray.add(dropdownValueMap);
      }

      await FirebaseFirestore.instance
          .collection(fetchedFieldName!)
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
    return FutureBuilder<void>(
      future: fetchComapnyname(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator while fetching the company name
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Create Itinery'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // Handle the error if fetching the company name fails
          return Text('Error: ${snapshot.error}');
        } else {
          // The company name has been fetched successfully
          // Continue building the widget tree
          return Scaffold(
            backgroundColor: Colors.grey[300],
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
                    leading: Icon(
                      Icons.home,
                      color: Colors.redAccent,
                    ),
                    title: const Text('Add Stays'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                      Navigator.pushNamed(context, MyRoutes.addStays);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.drive_eta_rounded,
                      color: Colors.redAccent,
                    ),
                    title: const Text('Add Vendors'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                      Navigator.pushNamed(context, MyRoutes.vendors);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.people,
                      color: Colors.redAccent,
                    ),
                    title: const Text('Travellers'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                      Navigator.pushNamed(context, MyRoutes.travellers);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.done_all,
                      color: Colors.redAccent,
                    ),
                    title: const Text('All Itenary'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Collections()),
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
                        NeoBox(
                          value: TextField(
                            onChanged: (value) {
                              try {
                                int parsedValue = int.parse(value);
                                if (parsedValue > 0) {
                                  numDropdownsvendor = parsedValue;
                                  _generateDropdownsforvendor();
                                }
                              } catch(e) {
                                numDropdownsvendor = 0;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter number of Drivers',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                            SizedBox(height: 20),
                            NeoBox(
                              value: Row(
                                children: [
                                  Text('Initial Date: ',style: TextStyle(fontSize: 20),),
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
                                      style: TextStyle(fontSize: 20, color: Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),

                            SizedBox(width: 10),
                            NeoBox(
                              value: Row(
                                children: [
                                  Text('Final Date: ',style: TextStyle(fontSize: 20),),
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
                                      style: TextStyle(fontSize: 20, color: Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                            ),


                        // TextField(
                        //   keyboardType: TextInputType.number,
                        //   onChanged: (value) {
                        //     numDropdowns = int.parse(value);
                        //     _generateDropdowns();
                        //   },
                        //   decoration: InputDecoration(
                        //     hintText: 'Enter number of Days',
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(15),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 20),

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(height: 10),

                StreamBuilder<QuerySnapshot>(
                  stream: vendorDropdownCollection.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    }
                    return DropdownButton<String>(
                      //  String vendordropdownValue = selectedVendorValue[document.id] ?? '';
                      value: selectedVendorValue,
                      items:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        return DropdownMenuItem<String>(
                          value: document.id,
                          child: Text(document.id),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedVendorValue = newValue!;
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
                            trailing: DropdownButton(
                              value: dropdownValues[index]['dropdownValue'],
                              items: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                return DropdownMenuItem(
                                  value: document.get('name'),
                                  child: Text(document.get('name')),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                setState(() {
                                  dropdownValues[index]['dropdownValue'] =
                                      value;
                                  dropdownValues[index]['selectedDate'] =
                                      dropdownDates[index];
                                });

                                QuerySnapshot querySnapshot =
                                    await dropdownsCollection
                                        .where('name', isEqualTo: value)
                                        .get();

                                if (querySnapshot.docs.isNotEmpty) {
                                  setState(() {
                                    dropdownValues[index]['Location'] =
                                        querySnapshot.docs[0]['location'];
                                    dropdownValues[index]['pluscode'] =
                                        querySnapshot.docs[0]['pluscode'];
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
                    future: vendorDropdownCollection
                        .doc(selectedVendorValue)
                        .collection(selectedVendorValue)
                        .get(),
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
                            trailing: DropdownButton(
                              value: selectedDriverValue[index]['Driver'],
                              items: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                return DropdownMenuItem(
                                  value: document.get('drivername'),
                                  child: Text(document.get('drivername')),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                setState(() {
                                  selectedDriverValue[index]['Driver'] = value;
                                });
                                QuerySnapshot querySnapshot =
                                    await vendorDropdownCollection
                                        .doc(selectedVendorValue)
                                        .collection(selectedVendorValue)
                                        .where('drivername', isEqualTo: value)
                                        .get();
                                if (querySnapshot.docs.isNotEmpty) {
                                  setState(() {
                                    selectedDriverValue[index]
                                            ['DriverLicense'] =
                                        querySnapshot.docs[0]['driverLicense'];
                                    selectedDriverValue[index]['DriverPhone'] =
                                        querySnapshot.docs[0]['driverphone'];
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {
                        // Your onPressed function
                        _saveToFirestore();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Proceed',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        primary: Colors.blue,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
