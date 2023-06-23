import 'package:firebase_auth/firebase_auth.dart';
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
  final TextEditingController _pluscode = TextEditingController();
  String? fetchedFieldName;

  @override
  void initState() {
    super.initState();
    fetchComapnyname(); // Fetch the field name when the widget is initialized
  }


  // Fetch the field name from Firebase
  Future<void> fetchComapnyname() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (snapshot.exists) {
        String? phone = snapshot.data()?['phone'] as String?;
        if (phone != null) {
          QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('number').get();

          if (querySnapshot.docs.isNotEmpty) {
            for (QueryDocumentSnapshot<Map<String, dynamic>> document
            in querySnapshot.docs) {
              List<dynamic> phoneArray = document.data()['phone'];
              for (int i = 0; i < phoneArray.length; i++) {
                if (phoneArray[i] is Map<String, dynamic>) {
                  Map<String, dynamic> map =
                  Map<String, dynamic>.from(phoneArray[i]);
                  if (map.containsValue(phone)) {
                    fetchedFieldName = map.keys.first;
                    break;
                  }
                } else if (phoneArray[i] == phone) {
                  fetchedFieldName = 'phone';
                  break;
                }
              }
            }
          }
        }
      }
    }
  }


  void _saveOption() {
    String optionValue = _optionController.text.trim();
    String phoneValue = _phoneController.text.trim();
    String locationValue = _locationController.text.trim();
    String pluscode = _pluscode.text.trim();

    if (optionValue.isNotEmpty && phoneValue.isNotEmpty && locationValue.isNotEmpty) {
      FirebaseFirestore.instance.collection(fetchedFieldName!).doc('Stays')
          .collection('Stays')
          .doc(locationValue)
          .set({
        'name': optionValue,
        'phone': phoneValue,
        'location': locationValue,
          'pluscode':pluscode
          })
          .then((value) => print('Option added'))
          .catchError((error) => print('Failed to add option: $error'));
      FirebaseFirestore.instance
          .collection(fetchedFieldName!)
          .doc('StaysInfo')
          .collection('StaysInfo').doc(optionValue).set(
          {'phone': phoneValue});


      FirebaseFirestore.instance
          .collection('Stays')
          .doc(locationValue)
          .set({
        'name': optionValue,
        'phone': phoneValue,
        'location': locationValue,
        'pluscode':pluscode
      })



          .then((value) => print('Option added'))
          .catchError((error) => print('Failed to add option: $error'));

      FirebaseFirestore.instance
          .collection('StaysInfo')
          .doc('StaysInfo')
          .collection('StaysInfo').doc(optionValue).set(
          {'phone': phoneValue});


      FirebaseFirestore.instance
          .collection('number')
          .doc('StaysInfo')
          .update({
        'phone': FieldValue.arrayUnion([
          {'$fetchedFieldName':phoneValue}
        ])
      });
      FirebaseFirestore.instance
          .collection('number')
          .doc('StaysInfo')
          .update({
        'num': FieldValue.arrayUnion([phoneValue])
      });
      _optionController.clear();
      _phoneController.clear();
      _locationController.clear();
      _pluscode.clear();
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
              TextField(
                controller: _pluscode,
                decoration: InputDecoration(
                  labelText: 'Enter Google PlusCode',
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
