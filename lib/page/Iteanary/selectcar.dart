import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outdoor_admin/page/Iteanary/collection.dart';

class SelectCar extends StatefulWidget {
  final String travellerid;

  SelectCar({Key? key, required this.travellerid}) : super(key: key);

  @override
  State<SelectCar> createState() => _SelectCarState(travellerid);
}

class _SelectCarState extends State<SelectCar> {
  String travellerid;
  late String collectionName;
  late int numDropdownsvendor =0;


  late CollectionReference dropdownsCollection;
  Map<int, dynamic> selectedValues = {};
  late CollectionReference userCollection;
  final _collectionNameController = TextEditingController();
  late TextEditingController phonenumbercontroller = TextEditingController();
  late CollectionReference vendorDropdownCollection;
  late DocumentReference driveDropdownCollection;
  late String selectedVendorValue = "Vaibhav";
  List<Map<String, dynamic>> selectedDriverValue = [];
  late String dropdownvalue = 'Vendor 1';

  _SelectCarState(this.travellerid) { }

  @override
  void initState() {
    super.initState();
    dropdownsCollection = FirebaseFirestore.instance.collection('Spiti').doc('Stays').collection('Stays');
    vendorDropdownCollection = FirebaseFirestore.instance.collection('Spiti').doc('Vendors').collection('vendors');
    userCollection = FirebaseFirestore.instance.collection('Spiti').doc('User').collection('Users');
  }

  void _generateDropdownsforvendor() {

    for (int i = 0; i < numDropdownsvendor; i++) {
      selectedDriverValue.add(
          {'d': null});
    }
  }


  void _saveToFirestore() async {
    _collectionNameController.text = travellerid;
    CollectionReference collectionRef =
    FirebaseFirestore.instance
        .collection('Spiti').doc('Users')
        .collection('Users')
        .doc(_collectionNameController.text)
        .collection(_collectionNameController.text);
    CollectionReference collectionRefvendor =
    FirebaseFirestore.instance
        .collection('Spiti').doc('Users')
        .collection('Users')
        .doc(_collectionNameController.text)
        .collection('vendor');

    for (int i = 0; i < numDropdownsvendor; i++) {
      await collectionRefvendor.add({
        'vendor': selectedDriverValue[i],
      });
    }


    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Data saved successfully!'),));

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => Collections()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Select Car'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [

                  SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      numDropdownsvendor = int.parse(value);
                      _generateDropdownsforvendor();
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter number of Car',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 10),
          SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: vendorDropdownCollection.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading...');
              }
              return DropdownButton<String>(

                value: selectedVendorValue,
                items: snapshot.data!.docs.map((DocumentSnapshot document) {
                  return DropdownMenuItem<String>(
                    value: document.id,
                    child: Text(document.id),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedVendorValue= newValue!;
                  });
                },
              );
            },
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: vendorDropdownCollection
                  .doc(selectedVendorValue)
                  .collection('vehicle')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return ListView.builder(
                  itemCount: numDropdownsvendor,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text('Vehicle ${index + 1}'),
                      trailing: DropdownButton(
                        value: selectedDriverValue[index]['Car'],
                        items: snapshot.data!.docs.map((
                            DocumentSnapshot document) {
                          return DropdownMenuItem(
                            value: document.get('CarName'),
                            child: Text(document.get('CarName')),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() async {
                            selectedDriverValue[index]['Car'] = value;
                            QuerySnapshot querySnapshot =
                            await vendorDropdownCollection
                                .doc(selectedVendorValue)
                                .collection('vehicle')
                                .where('CarName', isEqualTo: value)
                                .get();
                            if (querySnapshot.docs.isNotEmpty) {
                              setState(() {
                                selectedDriverValue[index]['CarNumber'] =
                                querySnapshot.docs[0]['CarNumber'];
                              });
                            }
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),





          ElevatedButton(
            onPressed: () {
              _saveToFirestore();

            },
            child: Text('Save Trip'),
          ),

      ],
      )
    );
  }
}