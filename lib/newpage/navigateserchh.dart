import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'editfile.dart';

class SearchItineraryPage extends StatefulWidget {
  @override
  _SearchItineraryPageState createState() => _SearchItineraryPageState();
}

class _SearchItineraryPageState extends State<SearchItineraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Itinerary"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('Itineraries').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              return ListTile(
                title: Text(doc['travellerid'] ?? 'Unknown ID'),
                onTap: () {
                  Map<String, dynamic> data =
                      doc.data()! as Map<String, dynamic>;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditItenaryPage(data: data)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
