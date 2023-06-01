import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Phone extends StatefulWidget {

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  String _subcollectionName = '';

  Future<String> findSubcollectionByPhoneNumber(String phoneNumber) async {
    final firestore = FirebaseFirestore.instance;
    final staySnapshot = await firestore.collectionGroup('Stay').where('phone', isEqualTo: phoneNumber).get();

    if (staySnapshot.docs.isNotEmpty) {
      return 'Stay';
    } else {
      return 'Subcollection not found';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Enter phone number'),
          keyboardType: TextInputType.number,
          onChanged: (value) async {
            String subcollectionName = await findSubcollectionByPhoneNumber(value);
            setState(() {
              _subcollectionName = subcollectionName;
            });
          },
        ),
        SizedBox(height: 20),
        Text(
          'Subcollection Name: $_subcollectionName',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
