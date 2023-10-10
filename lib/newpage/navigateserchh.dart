import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outdoor_admin/noe_box.dart';
import 'editfile.dart';

class SearchItineraryPage extends StatefulWidget {
  @override
  State<SearchItineraryPage> createState() => _SearchItineraryPageState();
}

class _SearchItineraryPageState extends State<SearchItineraryPage> {
  String? fetchedFieldName;

  @override
  void initState() {
    super.initState();
    fetchCompanyNameAndPhone();
  }
  DateTime currentTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: fetchedFieldName == null
          ? Center(
              child:
                  CircularProgressIndicator()) // If company name isn't fetched yet
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Itineraries')
                  .where('company', isEqualTo: fetchedFieldName)
                  .where('finalDateofTrip',
                      isLessThanOrEqualTo:
                      currentTime) // Filtering by company name
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print(DateTime.now());
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return NeoBox(
                  value: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NeoBox(
                          value: ListTile(
                            title: Text(doc['travellerid'] ?? 'Unknown ID'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(doc['groupLeadname'] ?? 'Unknown ID'),
                                Text(doc['pax'] ?? 'Unknown ID'),
                                Text(doc['vendor'] ?? 'Unknown ID'),
                              ],
                            ),
                            onTap: () {
                              Map<String, dynamic> data =
                                  doc.data()! as Map<String, dynamic>;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditItenaryPage(data: data)),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  Future<void> fetchCompanyNameAndPhone() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.phoneNumber != null) {
      final userPhone = user.phoneNumber!.substring(3); // Removing country code

      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('admin')
          .doc('hello')
          .get();

      if (docSnapshot.exists) {
        final dataMap = docSnapshot.data() as Map<String, dynamic>?;
        final usersData = dataMap?['userstype'] as List<dynamic>? ?? [];

        for (var userData in usersData) {
          if (userData['phone'] == userPhone) {
            fetchedFieldName = userData['company'] as String? ?? 'Unknown';
            setState(() {}); // Update the state to trigger a rebuild
            return;
          }
        }
      }
    }
  }
}
