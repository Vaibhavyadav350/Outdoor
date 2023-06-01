import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Traveller/travellerscreen.dart';

class FutureItenary extends StatefulWidget {
  @override
  _FutureItenaryState createState() => _FutureItenaryState();
}

class _FutureItenaryState extends State<FutureItenary> {
  List<String> _collections = [];

  @override
  void initState() {
    super.initState();
    getCollections().then((collections) {
      setState(() {
        _collections = collections ?? [];
      });
    });
  }

  Future<List<String>?> getCollections() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    .collection('Spiti').doc('Users')
        .collection('Users')
        .where('timestamp', isGreaterThan: DateTime.now())
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
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _collections.length,
        itemBuilder: (BuildContext context, int index) {
          String collection = _collections[index];
          DateTime timestamp = DateTime.now(); // Replace this with the actual timestamp from the document

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(collection),
              //subtitle: Text(timestamp as String),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TravellerScreen(
                       value: collection,
                      //timestamp: timestamp,
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