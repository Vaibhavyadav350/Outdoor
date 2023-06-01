import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddStays extends StatefulWidget {
  @override
  _AddStaysState createState() => _AddStaysState();
}

class _AddStaysState extends State<AddStays> {
  final TextEditingController _optionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  void _saveOption() {
    String optionValue = _optionController.text.trim();
    String phoneValue = _phoneController.text.trim();
    String locationValue = _locationController.text.trim();
    if (optionValue.isNotEmpty && phoneValue.isNotEmpty && locationValue.isNotEmpty) {
      FirebaseFirestore.instance.collection('Spiti').doc('Stays')
          .collection('Stays')
          .doc(locationValue)
          .set({
        'name': optionValue,
        'phone': phoneValue,
        'location': locationValue})
          .then((value) => print('Option added'))
          .catchError((error) => print('Failed to add option: $error'));
      FirebaseFirestore.instance
          .collection('Spiti')
          .doc('StaysInfo')
          .collection('StaysInfo').doc(optionValue).set(
          {'phone': phoneValue});
      FirebaseFirestore.instance
          .collection('number')
          .doc('StaysInfo')
          .update({
        'phone': FieldValue.arrayUnion([phoneValue])
      });
      _optionController.clear();
      _phoneController.clear();
      _locationController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add Stays'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32,vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset("assets/images/stays.jpg",
                fit: BoxFit.cover,height: 200,),
              TextField(
                controller: _optionController,
                decoration: InputDecoration(
                  labelText: 'Enter Stays',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Enter Phone Number',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Enter Location',
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
