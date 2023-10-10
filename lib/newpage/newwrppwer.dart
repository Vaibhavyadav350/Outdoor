// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:outdoor_admin/newpage/nenenenen.dart';
// import 'package:outdoor_admin/page/Iteanary/MainPage/collection.dart';
//
// import '../page/Iteanary/pax.dart';
// import 'dr.dart';
// import 'navigateserchh.dart';
// import 'newlogin.dart';
//
// class RoleDeterminer extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: _auth.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.active) {
//           final user = snapshot.data;
//           if (user == null) {
//             return NewLoginPage(); // Or whatever your login page is called
//           } else {
//             return FutureBuilder<DocumentSnapshot>(
//               future: _firestore.collection('admin').doc('hello').get(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   if (snapshot.hasData && snapshot.data!.exists) {
//                     final userTypeArray = snapshot.data!['userstype'] as List;
//
//                     // Search for the user's phone number in the userTypeArray
//                     var matchedUser = userTypeArray.firstWhere(
//                             (userInfo) => userInfo['phone'] == user.phoneNumber?.substring(3),
//                         orElse: () => null
//                     );
//
//                     if (matchedUser != null) {
//                       final userRole = matchedUser['role'] ?? '';
//                       switch (userRole) {
//                         case 'driver':
//                           return DriverTripsPage();
//                         case 'admin':
//                           return Collections();
//                         default:
//                           return DefaultPage();
//                       }
//                     } else {
//                       return ErrorPage();
//                     }
//                   } else {
//                     return ErrorPage();  // Display some error page or handle accordingly
//                   }
//                 }
//                 return CircularProgressIndicator();  // Loading indicator while fetching data
//               },
//             );
//           }
//         } else {
//           return CircularProgressIndicator();  // Loading indicator while checking auth state
//         }
//       },
//     );
//   }
// }
// class DefaultPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Default Dashboard')),
//       body: Center(child: Text('Welcome to the default page!')),
//     );
//   }
// }
// class ErrorPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Error')),
//       body: Center(child: Text('Oops! Something went wrong.')),
//     );
//   }
// }
