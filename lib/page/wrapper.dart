import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../phone.dart';
import 'Driver/DriverManager.dart';
import 'Iteanary/MainPage/collection.dart';
import 'Stays/StayManager.dart';

class Wrapper extends StatefulWidget {
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    fetchPhoneNumber();
  }

  void fetchPhoneNumber() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        phoneNumber = snapshot.get('phone') ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return PhoneNumberAuth();
          } else {
            return _buildNextScreen();
          }
        }
        return Scaffold(
          body: Center(child: Lottie.asset('assets/progress.json')),
        );
      },
    );
  }

  Widget _buildNextScreen() {
    if (phoneNumber.isEmpty) {
      return Scaffold(
        body: Center(child: Lottie.asset('assets/progress.json')),
      );
    }

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('number')
          .where('phone', arrayContains: phoneNumber)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: Lottie.asset('assets/progress.json')),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          String documentId = snapshot.data!.docs.first.id;
          print('Document ID: $documentId');

          if (documentId == 'StaysInfo') {
            print('Navigating to StayManager');
            return StayManager();
          } else if (documentId == 'DriverInfo') {
            print('Navigating to DriverManager');
            return DriverManage();
          } else if (documentId == 'Admin') {
            print('Navigating to Collections');
            return Collections();
          }
        }

        print('Phone number not found');
        return Scaffold(
          body: Center(child: Text('Phone number not found')),
        );
      },
    );
  }
}
