import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StayManagerPage extends StatefulWidget {
  @override
  _StayManagerPageState createState() => _StayManagerPageState();
}

class _StayManagerPageState extends State<StayManagerPage> {
  final _phoneController = TextEditingController();
  List<DocumentSnapshot> trips = [];
  String? fetchedFieldName;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> fetchCompanyNameAndPhone() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.phoneNumber != null) {
      final userPhone = user.phoneNumber!.substring(3); // Removing country code

      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('admin').doc('hello').get();

      if (docSnapshot.exists) {
        final dataMap = docSnapshot.data() as Map<String, dynamic>?;
        final usersData = dataMap?['userstype'] as List<dynamic>? ?? [];

        for (var userData in usersData) {
          if (userData['phone'] == userPhone) {
            fetchedFieldName = userData['company'] as String? ?? 'Unknown';
            _phoneController.text = userData['phone'] as String? ?? 'Unknown';
            setState(() {});
            return;
          }
        }
      }
    }
  }

  _fetchTrips(String phone) async {
    if (phone.isNotEmpty) {
      final tripDocs = await FirebaseFirestore.instance.collection('Itineraries').get();
      final filteredTrips = tripDocs.docs.where((doc) {
        final locations = doc['locations'] as List;
        for (var location in locations) {
          if (location['Phonenumber'] == phone) {
            return true;
          }
        }
        return false;
      }).toList();

      setState(() {
        trips = filteredTrips;
      });
    }
  }

  Future<void> initializeData() async {
    await fetchCompanyNameAndPhone();
    _fetchTrips(_phoneController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hotel Manager")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return ListTile(
                  title: Text('Trip ${index + 1}'),
                  subtitle: Text(
                      'From:  ${trip['initialDateofTrip']} \nTo:  ${trip['initialDateofTrip']}'
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
