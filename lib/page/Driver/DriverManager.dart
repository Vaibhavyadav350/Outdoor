import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class DriverManage extends StatefulWidget {
  @override
  _DriverManageState createState() => _DriverManageState();
}
class _DriverManageState extends State<DriverManage> {
  List<Map<String, dynamic>> dropdownValueArray = [];

  Future<void> _retrieveData(String phone) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Spiti')
        .doc('DriverInfo')
        .collection('DriverInfo')
        .where('phone', isEqualTo: phone)
        .get();
    querySnapshot.docs.forEach((doc) {
      dropdownValueArray = List<Map<String, dynamic>>.from(
          doc['Driver'] as List<dynamic>);
    });
    setState(() {}); // Trigger a rebuild after retrieving data
  }

  @override
  void initState() {
    super.initState();
    // Get the user's phone number from the Firestore collection
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          String? phone = snapshot.data()?['phone'] as String?;
          if (phone != null) {
            _retrieveData(phone);
          }
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Drives '),
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
                          bottomLeft: Radius.circular(20.0)),
                      color: Vx.amber50,
                    ),
                    child: ListTile(
                      leading: Column(
                        children: [
                          SizedBox(height: 10,),
                          Icon(Icons.home, color: Colors.lightGreen),
                        ],
                      ),
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Date: " + formattedDate),
                                Text("Pax: " +
                                    dropdownValueArray[index]['pax']),
                                Text("Phone: " +
                                    dropdownValueArray[index]
                                    ['groupLeadContact']),
                                Text("Stay: " +
                                    dropdownValueArray[index]
                                    ['dropdownValue']),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Redirect to call page with the group lead contact number
                              String phoneNumber =
                              dropdownValueArray[index]['groupLeadContact'];
                              String ph = phoneNumber
                                  .replaceAll(RegExp(r'[^0-9]'), '');
                              String telUrl = 'tel:$ph';
                              launch(telUrl);
                            },
                            child: Column(
                              children: [SizedBox(height: 25,),
                                Icon(Icons.call, color: Colors.blue),
                              ],
                            ),
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
