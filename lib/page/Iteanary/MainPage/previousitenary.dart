import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

import '../../Traveller/travellerscreen.dart';

class PreviousItenary extends StatefulWidget {
  @override
  _PreviousItenaryState createState() => _PreviousItenaryState();
}

class _PreviousItenaryState extends State<PreviousItenary> {
  List<String> _collections = [];
  String previous = "Previous Itenary";
  String OnGoing = "Ongoing Itenary";
  String Later = "Future Itenary";
  int _selecteditem = 0;
  String fieldName = '';
  String documentId = ''; // Added documentId variable

  @override
  void initState() {
    super.initState();
    fetchComapnyname();
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
                    documentId = document.id;
                    fieldName = map.keys.first;
                    break;
                  }
                } else if (phoneArray[i] == phone) {
                  documentId = document.id;
                  fieldName = 'phone';
                  break;
                }
              }
            }
          }
        }
      }
    }
    List<String> collections = await getCollections(fieldName);
    setState(() {
      _collections = collections;
    });
  }

  Future<List<String>> getCollections(String fieldName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(fieldName)
        .doc('Users')
        .collection('Users')
        .where('timestamp', isLessThan: DateTime.now())
        .get();

    List<String> collections = [];
    for (var collection in querySnapshot.docs) {
      collections.add(collection.id);
    }
    return collections;
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: _collections.isEmpty
          ? Center(
        child: Lottie.asset('assets/progress.json'),
      )
          : ListView.builder(
        itemCount: _collections.length,
        itemBuilder: (BuildContext context, int index) {
          String collection = _collections[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(collection),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TravellerScreen(
                      value: collection,
                    ),
                  ),
                );
              },
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        },
      ),
    );
  }
}