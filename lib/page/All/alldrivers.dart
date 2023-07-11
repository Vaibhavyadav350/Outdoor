import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllVendorPage extends StatefulWidget {
  @override
  _AllVendorPageState createState() => _AllVendorPageState();
}

class _AllVendorPageState extends State<AllVendorPage> {
  List<String> optionValues = [];
  String? company;

  @override
  void initState() {
    super.initState();
    fetchComapnyname();
    fetchOptionValues();
  }
  Future<void> fetchComapnyname() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

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
                    company = map.keys.first;
                    break;
                  }
                } else if (phoneArray[i] == phone) {
                  company = 'phone';
                  break;
                }
              }
            }
          }
        }
      }
    }
  }

  void fetchOptionValues() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('vendors')
        .get();
    List<String> values = snapshot.docs.map((doc) => doc.id).toList();
    setState(() {
      optionValues = values;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Options'),
      ),
      body: ListView.builder(
        itemCount: optionValues.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(optionValues[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DriverDetailPage(optionValue: optionValues[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DriverDetailPage extends StatelessWidget {
  final String optionValue;

  DriverDetailPage({required this.optionValue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(optionValue),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('vendors')
              .doc(optionValue)
              .collection(optionValue)
              .limit(1)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text('No data available for $optionValue');
            }

            Map<String, dynamic>? data = snapshot.data!.docs[0].data() as Map<String, dynamic>?;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Driver Name: ${data?['drivername']}'),
                Text('Driver Phone Number: ${data?['driverphone']}'),
                Text('Driver License: ${data?['driverLicense']}'),
                Text('Company: ${data?['company']}'),
              ],
            );
          },
        ),
      ),
    );
  }
}
