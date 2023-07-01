import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:outdoor_admin/page/Driver/DriverManager.dart';
import 'package:outdoor_admin/page/Iteanary/MainPage/collection.dart';
import 'package:outdoor_admin/page/Stays/StayManager.dart';

class PhoneNumberAuth extends StatefulWidget {
  @override
  _PhoneNumberAuthState createState() => _PhoneNumberAuthState();
}

class _PhoneNumberAuthState extends State<PhoneNumberAuth> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String _verificationId = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }


  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String phoneNumber = "+91" + _phoneNumberController.text.trim();

    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        _navigateToNextScreen();
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Phone number verification failed: ${e.message}');
        setState(() {
          _isLoading = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) async {
        setState(() {
          _verificationId = verificationId;
          _isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
  Future<void> _verifyOTP(String otp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: otp,
    );
    _navigateToNextScreen();

    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signInWithCredential(credential);
    createNewAccount(auth.currentUser!.uid);
  }
  void createNewAccount(String userId) {
    // Set the initial account information for the user
    FirebaseFirestore.instance.collection('users').doc(userId).set({
      'createdAt': FieldValue.serverTimestamp(),
      'phone':_phoneNumberController.text.trim()
      // add any other user-related information here
    });
  }

  void _navigateToNextScreen() {
    String phoneNumber = _phoneNumberController.text.trim();

    FirebaseFirestore.instance
        .collection('number')
        .where('phone', arrayContains: phoneNumber)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        String documentId = snapshot.docs.first.id;
        print('Document ID: $documentId');

        if (documentId == 'StaysInfo') {
          print('Navigating to StayManager');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StayManager()),
          );
        } else if (documentId == 'DriverInfo') {
          print('Navigating to DriverManager');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DriverManage()),
          );
        } else if (documentId == 'Admin') {
          print('Navigating to Collections');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Collections()),
          );
        }
      } else {
        print('Phone number not found');
        // Phone number not found, handle accordingly
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: Text('Login')),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/traveller.jpg",
                  fit: BoxFit.cover,
                  height: 180,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendOTP,
                  child: _isLoading ? CircularProgressIndicator() : Text('Send OTP'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Visibility(
                  visible: _verificationId.isNotEmpty,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,

                        decoration: InputDecoration(
                          labelText: 'Enter OTP',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          prefixIcon: Icon(Icons.key),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please enter the OTP';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            String otp = _otpController.text.trim();
                            _verifyOTP(otp);
                          }
                        },
                        child: Text('Submit OTP'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
