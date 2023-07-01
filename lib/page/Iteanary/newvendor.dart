import 'package:firebase_auth/firebase_auth.dart';
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
  String? fetchedFieldName; // Variable to store the fetched field name

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
    String drivername = _drivername.text.trim();
    String driverphonenumber = _driverphonenumber.text.trim();
    String driverLicense = _driverdrivingLicense.text.trim();
    if (optionValue.isNotEmpty) {
      FirebaseFirestore.instance
          .collection(fetchedFieldName!).doc('Vendors')
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
          .collection(fetchedFieldName!).doc('Vendors')
          .collection('vendors').doc(optionValue)
          .set({'optionValue':optionValue});
      FirebaseFirestore.instance
          .collection(fetchedFieldName!)
          .doc('DriverInfo')
          .collection('DriverInfo').doc(drivername).set(
          {'phone': driverphonenumber});
      FirebaseFirestore.instance
          .collection('number')
          .doc('DriverInfo')
          .update({
        'phone': FieldValue.arrayUnion([
          {'$fetchedFieldName':driverphonenumber}
        ])
      });
      FirebaseFirestore.instance
          .collection('number')
          .doc('DriverInfo')
          .update({
        'num': FieldValue.arrayUnion([driverphonenumber])
      });





      FirebaseFirestore.instance

          .collection('Driver')
          .doc(optionValue)
          .collection(optionValue as String)
          .add({'drivername': drivername,
        'driverphone':driverphonenumber,'driverLicense':driverLicense})
          .then((value) => print('Option added'))
          .catchError((error) => print('Failed to add option: $error'
      )
      );
      FirebaseFirestore.instance
          .collection('number')
          .doc('DriverInfo')
          .update({
        'phone': FieldValue.arrayUnion([
          {'$fetchedFieldName':driverphonenumber}
        ])
      });
      FirebaseFirestore.instance
          .collection('number')
          .doc('DriverInfo')
          .update({
        'num': FieldValue.arrayUnion([driverphonenumber])
      });
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
                keyboardType: TextInputType.number,
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
