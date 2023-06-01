import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewVendors extends StatefulWidget {
  @override
  _NewVendorsState createState() => _NewVendorsState();
}

class _NewVendorsState extends State<NewVendors> {
  final TextEditingController _optionController = TextEditingController();
  final TextEditingController _drivername =TextEditingController();
  final TextEditingController _driverphonenumber =TextEditingController();
  final TextEditingController _driverdrivingLicense =TextEditingController();
  //final TextEditingController _driver =TextEditingController();

  void _saveOption() {
    String optionValue = _optionController.text.trim();
    String drivername = _drivername.text.trim();
    String driverphonenumber = _driverphonenumber.text.trim();
    String driverLicense = _driverdrivingLicense.text.trim();
    if (optionValue.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('Spiti').doc('Vendors')
          .collection('vendors')
          .doc(optionValue)
          .collection(optionValue as String)
          .add({'drivername': drivername,
        'driverphone':driverphonenumber,'driverLicense':driverLicense})
          .then((value) => print('Option added'))
          .catchError((error) => print('Failed to add option: $error'
      )
      );
      FirebaseFirestore.instance
          .collection('Spiti').doc('Vendors')
          .collection('vendors').doc(optionValue)
          .set({'optionValue':optionValue});
      FirebaseFirestore.instance.collection('SpitiDriver').doc(drivername).set(
          {'phone': driverphonenumber});
      _optionController.clear();
      _drivername.clear();
      _driverdrivingLicense.clear();
      _driverphonenumber.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add Drivers'),
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
                controller: _optionController,
                decoration: InputDecoration(
                  labelText: 'Vendor Name',
                ),
              ),
              TextField(
                controller: _drivername,
                decoration: InputDecoration(
                  labelText: 'Driver Name',
                ),
              ),
              TextField(
                controller: _driverphonenumber,
                decoration: InputDecoration(
                  labelText: 'Driver PhoneNumber',
                ),
              ),
              TextField(
                controller: _driverdrivingLicense,
                decoration: InputDecoration(
                  labelText: 'Driver License',
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
