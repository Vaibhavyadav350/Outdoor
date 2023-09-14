import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../newpage/name&company.dart';

class AddPropertyPage extends StatefulWidget {
  @override
  _AddPropertyPageState createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  final _managername = TextEditingController();
  final _property = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _companyController = TextEditingController();
  final _phoneController_user = TextEditingController();
  final dataFetcher = DataFetcher();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _saveOption() async {
    final data = await dataFetcher.fetchCompanyNameAndPhone();

    setState(() {
      _companyController.text = data['company'] ?? '';
      _phoneController_user.text = data['phone'] ?? '';
    });

    try {
      await _firestore.collection('Stays').add({
        'managerName': _managername.text,
        'propertyName': _property.text,
        'phoneNumber': _phoneController.text,
        'location': _locationController.text,
        'onboardedby': _phoneController_user.text,
        'company': _companyController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved Successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $error')),
      );
    }

    // Clearing the fields after saving.
    _managername.clear();
    _property.clear();
    _phoneController.clear();
    _locationController.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add Property'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "assets/images/stays.jpg",
                fit: BoxFit.cover,
                height: 200,
              ),
              TextField(
                controller: _managername,
                decoration: InputDecoration(
                  labelText: 'Stay Manager Name',
                ),
              ),
              TextField(
                controller: _property,
                decoration: InputDecoration(
                  labelText: 'Enter Property Name',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                keyboardType: TextInputType.number,
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
