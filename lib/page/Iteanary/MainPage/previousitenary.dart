import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:outdoor_admin/noe_box.dart';

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
    List<Map<String, dynamic>> collections = await getCollections(fieldName);
    _collections = collections
        .map((collection) => collection['collectionId'] as String)
        .toList();
    setState(() {
      _collections = _collections;
    });
  }

  Future<List<Map<String, dynamic>>> getCollections(String fieldName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        // .collection(fieldName)
        // .doc('Users')
        .collection('Users')
        .where('company', isEqualTo: fieldName)
        .where('timestamp', isLessThan: DateTime.now())

        .get();

    List<Map<String, dynamic>> collections = [];
    for (var collection in querySnapshot.docs) {
      String collectionId = collection.id;
      Map<String, dynamic>? collectionData =
          collection.data() as Map<String, dynamic>?;

      // Fetch the "name" field from the collection data
      String? name = collectionData?['name'] as String?;

      // Check if name is not null before using it
      if (name != null) {
        // Create a map with the collection ID and the name
        Map<String, dynamic> collectionInfo = {
          'collectionId': collectionId,
          'name': name,
        };

        collections.add(collectionInfo);
      }
    }

    print('collection: $collections');
    return collections;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: _collections.isEmpty
          ? Center(
              child: Lottie.asset('assets/progress.json'),
            )
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: getCollections(fieldName),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Lottie.asset('assets/progress.json'),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  List<Map<String, dynamic>> collections = snapshot.data!;
                  if (collections.isEmpty) {
                    return Center(
                      child: Text('No collections available.'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: collections.length,
                      itemBuilder: (BuildContext context, int index) {
                        String collection =
                            collections[index]['name'] as String;
                        String documentId =
                            collections[index]['collectionId'] as String;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TravellerScreen(
                                    value: documentId,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: SizedBox(
                                height: 60,
                                child: NeoBox(
                                  value: Row(
                                    children: [
                                      SizedBox(width: 20),
                                      Image.asset(
                                        "assets/images/location.png",
                                        width: 24,
                                        height: 24,
                                      ),
                                      SizedBox(width: 30),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            documentId,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Traveller: $collection',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 30),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                } else {
                  return Center(
                    child: Text('No data available.'),
                  );
                }
              },
            ),
    );
  }
}
