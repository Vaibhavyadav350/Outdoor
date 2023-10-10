import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../newpage/name&company.dart';

class NewVendors extends StatefulWidget {
  @override
  _NewVendorsState createState() => _NewVendorsState();
}

class _NewVendorsState extends State<NewVendors> {
  final _vendorname = TextEditingController();
  final _drivername = TextEditingController();
  final _phoneController = TextEditingController();
  final _license_number = TextEditingController();
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
      await _firestore.collection('Driver').doc(_drivername.text).set({
        'vendor': _vendorname.text,
        'driver': _drivername.text,
        'phone': _phoneController.text,
        'license': _license_number.text,
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
    _vendorname.clear();
    _drivername.clear();
    _phoneController.clear();
    _license_number.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add Driver'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "assets/images/driver.jpg",
                fit: BoxFit.cover,
                height: 200,
              ),
              TextField(
                controller: _vendorname,
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
                controller: _license_number,
                decoration: InputDecoration(
                  labelText: 'Enter License',
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
