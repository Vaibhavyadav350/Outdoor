import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../theme/colors.dart';


class TravellerData extends StatefulWidget {

  @override
  _TravellerDataState createState() => _TravellerDataState();

}

class _TravellerDataState extends State<TravellerData> {

  final _collectionNameController = TextEditingController();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _documents = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _vendordocuments = [];
  @override
  void dispose() {
    _collectionNameController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    // Fetch data from Firestore
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(_collectionNameController.text)
        .collection(_collectionNameController.text)
        .get();
    setState(() {
      _documents = snapshot.docs;
    });
    QuerySnapshot<Map<String, dynamic>> snapshots = await FirebaseFirestore.instance
        .collection("users")
        .doc(_collectionNameController.text)
        .collection('vendor')
        .get();
    setState(() {
      _vendordocuments = snapshots.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travellers Data'),
        centerTitle: true,
      ),
       body: Container(
         decoration: BoxDecoration(
           gradient: LinearGradient(
             colors: [appBgColorSecondary, appBgColorPrimary],
           ),

         ),
         child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _collectionNameController,
                decoration: InputDecoration(
                  labelText: 'Enter traveller ID',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _fetchData,
                child: Text('Fetch Data'),
              ),
              SizedBox(height: 16.0),
              Flexible(
                child: _documents.isEmpty
                    ? Center(child: Text('No data found'))

                : ListView.builder(

                  itemCount: _documents.length,
                  itemBuilder: (BuildContext context, int index) {

                    Map<String, dynamic> data = _documents[index].data();
                  //  Map<String, dynamic> vdata =  _vendordocuments[index].data();
                    Timestamp timestamp = data['selectedDate'];
                    DateTime dateTime = timestamp.toDate();
                    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
                    bool isFutureDate = dateTime.isBefore(DateTime.now());
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                      ),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                              title: Text(
                              data['dropdownValue'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Date: $formattedDate',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                            trailing: isFutureDate
                                ? Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),

              ),




              Flexible(
                child: ListView.builder(

                  itemCount: _vendordocuments.length,
                  itemBuilder: (BuildContext context, int ink) {

                    Map<String, dynamic> vdata =  _vendordocuments[ink].data();
                    String driver = vdata['vendor']['Driver'];

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                      ),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              " Driver : " +
                              driver,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
      ),
       ),
    );
  }
}
