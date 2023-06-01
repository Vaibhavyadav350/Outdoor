import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Traveller/travellerscreen.dart';

class Ongoing extends StatefulWidget {
  @override
  _OngoingState createState() => _OngoingState();
}

class _OngoingState extends State<Ongoing> {
  List<String> _collections = [];
  String previous = "Previous Itenary";
  String OnGoing = "Ongoing Itenary";
  String Later = "Future Itenary";
  int _selecteditem =0;
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
        .where('timestamp')
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
      child: _collections.isEmpty ? Center(
        child: CircularProgressIndicator(),
      )
          :  ListView.builder(
        itemCount: _collections.length,
        itemBuilder: (BuildContext context, int index) {
          String collection = _collections[index];
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
