import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addUserInfo() async {
    if (_roleController.text.isNotEmpty &&
        _companyController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty) {
      try {
        await _firestore.collection('admin').doc("hello").update({
          'userstype': FieldValue.arrayUnion([{
            'role': _roleController.text.trim(),
            'company': _companyController.text.trim(),
            'phone': _phoneController.text.trim(),
          }])
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User information added successfully!')),
        );
      } catch (e) {
        // If the document doesn't exist, create it with initial data
        if (e is FirebaseException && e.code == 'not-found') {
          await _firestore.collection('admin').doc("hello").set({
            'userstype': [{
              'role': _roleController.text.trim(),
              'company': _companyController.text.trim(),
              'phone': _phoneController.text.trim(),
            }]
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User information added successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add User Info')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _roleController,
              decoration: InputDecoration(labelText: 'Role'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _companyController,
              decoration: InputDecoration(labelText: 'Company'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addUserInfo,
              child: Text('Add Info to Firestore'),
            ),
          ],
        ),
      ),
    );
  }
}
