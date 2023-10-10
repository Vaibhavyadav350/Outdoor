// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class NewLoginPage extends StatefulWidget {
//   @override
//   _NewLoginPageState createState() => _NewLoginPageState();
// }
//
// class _NewLoginPageState extends State<NewLoginPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String _phoneNumber = '';
//   String _smsCode = '';
//   String _verificationId = '';
//   bool _codeSent = false;
//
//   Future<void> _verifyPhoneNumber() async {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: '+91' + _phoneNumber, // Assuming it's for India with the '+91' country code
//       timeout: const Duration(seconds: 60),
//       verificationCompleted: (PhoneAuthCredential authCredential) async {
//         // If Firebase successfully authenticates with the provided number instantly, this callback gets triggered.
//         await _auth.signInWithCredential(authCredential);
//       },
//       verificationFailed: (FirebaseAuthException authException) {
//         // Handle verification failure
//         print('Verification failed: ${authException.message}');
//       },
//       codeSent: (String verificationId, [int? forceResendingToken]) {
//         setState(() {
//           _verificationId = verificationId;
//           _codeSent = true;
//         });
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         // Handle case where auto-retrieval times out
//         _verificationId = verificationId;
//       },
//     );
//   }
//
//   Future<void> _signInWithPhoneNumber() async {
//     final PhoneAuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: _verificationId,
//       smsCode: _smsCode,
//     );
//     try {
//       await _auth.signInWithCredential(credential);
//       // Successfully signed in
//     } catch (e) {
//       // Sign in failed
//       print('Sign-in error: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Phone Number Login')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               onChanged: (value) {
//                 setState(() {
//                   _phoneNumber = value;
//                 });
//               },
//               decoration: InputDecoration(labelText: 'Phone Number'),
//               keyboardType: TextInputType.phone,
//             ),
//             _codeSent
//                 ? TextField(
//               onChanged: (value) {
//                 setState(() {
//                   _smsCode = value;
//                 });
//               },
//               decoration: InputDecoration(labelText: 'Enter OTP'),
//               keyboardType: TextInputType.number,
//             )
//                 : Container(),
//             _codeSent
//                 ? ElevatedButton(
//               onPressed: _signInWithPhoneNumber,
//               child: Text('Verify and Sign in'),
//             )
//                 : ElevatedButton(
//               onPressed: _verifyPhoneNumber,
//               child: Text('Send OTP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
