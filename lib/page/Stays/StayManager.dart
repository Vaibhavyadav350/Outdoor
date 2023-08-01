import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class StayManager extends StatefulWidget {
  @override
  _StayManagerState createState() => _StayManagerState();
}

class _StayManagerState extends State<StayManager> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otp = TextEditingController();
  List<Map<String, dynamic>> dropdownValueArray = [];

  Future<void> _retrieveData(String phone) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('StaysInfo')
        .where('phone', isEqualTo: phone)
        .get();

    querySnapshot.docs.forEach((doc) {
      dropdownValueArray = List<Map<String, dynamic>>.from(
          doc['dropdownValue'] as List<dynamic>);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stay Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/images/myinfo.jpg",
                fit: BoxFit.cover,
                height: 300,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Enter Phone Number',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await _retrieveData(_phoneController.text);
                  setState(() {});
                },
                child: Text('Go to Bookings'),
              ),
              SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: dropdownValueArray.length,
                itemBuilder: (context, index) {
                  DateTime selectedDate =
                  (dropdownValueArray[index]['selectedDate'] as Timestamp)
                      .toDate();
                  String formattedDate =
                  DateFormat('yyyy-MM-dd').format(selectedDate);
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
                      leading: Icon(Icons.home, color: Colors.lightGreen),
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Date: " + formattedDate),
                                Text("Pax: " + dropdownValueArray[index]['pax']),
                                Text("Phone: " + dropdownValueArray[index]['groupLeadContact']),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Redirect to call page with the group lead contact number
                              String phoneNumber = dropdownValueArray[index]['groupLeadContact'];
                              String ph = phoneNumber.replaceAll(RegExp(r'[^0-9]'), ''); // Remove non-numeric characters from the phone number
                              String telUrl = 'tel:$ph'; // Construct the tel URL
                              launch(telUrl); // Launch the phone call
                            },
                            child: Icon(Icons.call, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
