import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class PlusCodeMapScreen extends StatefulWidget {
  @override
  _PlusCodeMapScreenState createState() => _PlusCodeMapScreenState();
}

class _PlusCodeMapScreenState extends State<PlusCodeMapScreen> {
  String plusCode = '';

  @override
  void initState() {
    super.initState();
    retrievePlusCode();
  }

  void retrievePlusCode() async {
    // Replace 'your_collection' and 'your_document_id' with your Firestore collection and document ID
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('number')
        .doc('Admin')
        .get();

    setState(() {
      plusCode = snapshot.get('pluscode');
    });
  }
  void openGoogleMaps() async {
    final encodedPlusCode = Uri.encodeComponent(plusCode);
    final googleMapsUrl = 'https://maps.google.com/?q=$encodedPlusCode';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      // Handle error if Google Maps app is not installed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Google Maps app is not installed.'),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google PlusCode'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PlusCode: $plusCode',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                openGoogleMaps();
              },
              child: Text('Open in Google Maps'),
            ),
          ],
        ),
      ),
    );
  }
}
