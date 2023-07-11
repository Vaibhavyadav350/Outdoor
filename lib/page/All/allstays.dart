import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AllStays extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotels List'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('Stays').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              String name = documents[index].data()['name'];

              return ListTile(
                title: Text(name),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteStay(documents[index].reference);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NameStaysPage(name: name),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _deleteStay(DocumentReference<Map<String, dynamic>> documentReference) {
    return documentReference.delete();
  }
}
class NameStaysPage extends StatelessWidget {
  final String name;

  NameStaysPage({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Name Info'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Stays')
            .where('name', isEqualTo: name)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Text('No data found for $name');
          }

          Map<String, dynamic> data = snapshot.data!.docs[0].data() as Map<String, dynamic>;
          String company = data['company'];
          String phone = data['phone'];
          String location = data['location'];
          String pluscode = data['pluscode'];

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Name: $name'),
                Text('Company: $company'),
                Text('Phone: $phone'),
                Text('Location: $location'),
                Text('Pluscode: $pluscode'),
              ],
            ),
          );
        },
      ),
    );
  }
}