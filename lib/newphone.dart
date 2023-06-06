import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreQueryExample extends StatefulWidget {
  @override
  _FirestoreQueryExampleState createState() => _FirestoreQueryExampleState();
}

class _FirestoreQueryExampleState extends State<FirestoreQueryExample> {
  final String targetValue = '4534346'; // The value to search for
  String documentId = '';
  String fieldName = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('number')
        .get();

    if (snapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> document in snapshot.docs) {
        List<dynamic> phoneArray = document.data()['phone'];
        for (int i = 0; i < phoneArray.length; i++) {
          if (phoneArray[i] is Map<String, dynamic>) {
            Map<String, dynamic> map = Map<String, dynamic>.from(phoneArray[i]);
            if (map.containsValue(targetValue)) {
              documentId = document.id;
              fieldName = map.keys.first;
              break;
            }
          } else if (phoneArray[i] == targetValue) {
            documentId = document.id;
            fieldName = 'phone';
            break;
          }
        }
      }
    }

    setState(() {}); // Update the UI with the retrieved data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Query Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Document ID: $documentId',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Field Name: $fieldName',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
