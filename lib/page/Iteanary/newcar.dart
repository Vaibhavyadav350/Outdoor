import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewCar extends StatefulWidget {
  @override
  _NewCarState createState() => _NewCarState();
}

class _NewCarState extends State<NewCar> {
  final TextEditingController _vendorname = TextEditingController();
  final TextEditingController _carname =TextEditingController();
  final TextEditingController _carnumber =TextEditingController();
  final TextEditingController _sittingcapacity =TextEditingController();
  //final TextEditingController _driver =TextEditingController();

  void _saveOption() {
    String vendorname = _vendorname.text.trim();
    String carname = _carname.text.trim();
    String carnumber = _carnumber.text.trim();
    String sittingcapacity = _sittingcapacity.text.trim();

    if (vendorname.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('Spiti').doc('Vendors')
          .collection('vendors')
          .doc(vendorname)
          .collection('vehicle')
          .add(
          {
            'CarName': carname,
        'CarNumber':carnumber,
        'SittingCapacity':sittingcapacity
          }
      )
          .then((value) => print('Option added'))
          .catchError((error) => print('Failed to add option: $error'
      )
      );
      FirebaseFirestore.instance
          .collection('Spiti').doc('Vendors')
          .collection('vendors')
          .doc(vendorname)
          .set({'vendorname':vendorname})
      ;
      _vendorname.clear();
      _carname.clear();
      _sittingcapacity.clear();
      _carnumber.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add Cars'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32,vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset("assets/images/vendors.jpg",
                fit: BoxFit.cover,height: 200,),
              TextField(
                controller: _vendorname,
                decoration: InputDecoration(
                  labelText: 'Vendor Name',
                ),
              ),
              TextField(
                controller: _carname,
                decoration: InputDecoration(
                  labelText: 'Car Name',
                ),
              ),
              TextField(
                controller: _carnumber,
                decoration: InputDecoration(
                  labelText: 'Car Number',
                ),
              ),
              TextField(
                controller: _sittingcapacity,
                decoration: InputDecoration(
                  labelText: 'Sitting Capacity',
                ),
              ),

              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveOption,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
