// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:outdoor_admin/newpage/nenenenen.dart';
//
//
// // import 'package:flutter_sms/flutter_sms.dart';
// import 'package:outdoor_admin/page/Iteanary/itenary.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// class Pax extends StatefulWidget {
//   const Pax({Key? key}) : super(key: key);
//
//   @override
//   State<Pax> createState() => _PaxState();
// }
//
// class _PaxState extends State<Pax> {
//   late TextEditingController _pax;
//   late TextEditingController _travellerid;
//   late TextEditingController _groupLeadContact;
//   late TextEditingController _groupLeadname;
//   String? fetchedFieldName;
//
//   // //late TwilioFlutter twilioFlutter;
//   // TwilioFlutter twilioFlutter = TwilioFlutter(
//   // accountSid : 'AC475ab9b4d2f308d0fce82dc172cd2e98', // replace *** with Account SID
//   // authToken : 'acbc742766a26762be167b87c94fc61f',  // replace xxx with Auth Token
//   // twilioNumber : '+14155238886'  // replace .... with Twilio Number
//   // );
//
//   @override
//   void initState() {
//     super.initState();
//
//     _pax = TextEditingController();
//     _travellerid = TextEditingController();
//     _groupLeadContact = TextEditingController();
//     _groupLeadname = TextEditingController();
//
//     // Generate and set the initial value of traveler ID
//     fetchComapnyname().then((_) {
//       generateTravelerId().then((generatedId) {
//         setState(() {
//           _travellerid.text = generatedId;
//         });
//       });
//     });
//   }
//
//   Future<void> fetchComapnyname() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       String userId = user.uid;
//       DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
//           .instance
//           .collection('users')
//           .doc(userId)
//           .get();
//
//       if (snapshot.exists) {
//         String? phone = snapshot.data()?['phone'] as String?;
//         if (phone != null) {
//           QuerySnapshot<Map<String, dynamic>> querySnapshot =
//               await FirebaseFirestore.instance.collection('number').get();
//
//           if (querySnapshot.docs.isNotEmpty) {
//             for (QueryDocumentSnapshot<Map<String, dynamic>> document
//                 in querySnapshot.docs) {
//               List<dynamic> phoneArray = document.data()['phone'];
//               for (int i = 0; i < phoneArray.length; i++) {
//                 if (phoneArray[i] is Map<String, dynamic>) {
//                   Map<String, dynamic> map =
//                       Map<String, dynamic>.from(phoneArray[i]);
//                   if (map.containsValue(phone)) {
//                     fetchedFieldName = map.keys.first;
//                     break;
//                   }
//                 } else if (phoneArray[i] == phone) {
//                   fetchedFieldName = 'phone';
//                   break;
//                 }
//               }
//             }
//           }
//         }
//       }
//     }
//   }
//
//   Future<String> generateTravelerId() async {
//     CollectionReference travelersCollection = FirebaseFirestore.instance.collection('travelers');
//     QuerySnapshot querySnapshot = await travelersCollection.orderBy('numericId', descending: true).limit(1).get();
//
//     int latestNumericId = 0;
//     if (querySnapshot.docs.isNotEmpty) {
//       latestNumericId = querySnapshot.docs.first.get('numericId') as int;
//     }
//     int newNumericId = latestNumericId + 1;
//     return 'T2023$newNumericId';
//   }
//
//   Future<void> saveTravelerIdToFirestore(String travelerId, String groupLeadContact) async {
//     String phoneValue = groupLeadContact;
//     CollectionReference travelersCollection = FirebaseFirestore.instance.collection('travelers');
//
//     int substringStartIndex = 5;
//     int travelerIdLength = travelerId.length;
//
//     if (substringStartIndex < travelerIdLength) {
//       String numericIdString = travelerId.substring(substringStartIndex);
//       int numericId = int.parse(numericIdString);
//
//       QuerySnapshot snapshot = await travelersCollection.where('numericId', isEqualTo: numericId).get();
//
//       if (snapshot.docs.isEmpty) {
//         await travelersCollection.add({
//           'numericId': numericId,
//           // Add other fields as per your requirements
//         });
//       } else {
//         print('Document already exists with numericId: $numericId');
//       }
//     } else {
//       print('Substring start index is out of range for travelerId: $travelerId');
//     }
//
//     FirebaseFirestore.instance.collection('number').doc('Traveller').update({
//       'phone': FieldValue.arrayUnion([phoneValue]),
//       'num': FieldValue.arrayUnion([phoneValue])
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     const List<String> list1 = <String>['5 Seater', '7 Seater'];
//     const List<String> list2 = <String>['1 Car', '2 Car', '3 Car', '4 Car'];
//     String SeaterDropdown = list1.first;
//     String CarNumbersDropdown = list2.first;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(title: const Text("Traveller Details")),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//         child: ListView(
//           children: [
//             Column(
//               children: [
//                 Column(
//                   children: [
//                     Image.asset(
//                       "assets/images/pax.jpg",
//                       fit: BoxFit.cover,
//                       height: 200,
//                     ),
//                     ListTile(
//                       leading: Icon(Icons.group_add, color: Colors.green),
//                       title: TextField(
//                         keyboardType: TextInputType.number,
//                         controller: _pax,
//                         decoration: InputDecoration(
//                           hintText: 'PAX',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     ListTile(
//                       leading: Icon(Icons.numbers, color: Colors.red),
//                       title: TextField(
//                         controller: _travellerid,
//                         enabled: false,
//                         decoration: InputDecoration(
//                           hintText: 'Traveller ID',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     ListTile(
//                       leading: Icon(Icons.phone, color: Colors.blue),
//                       title: TextField(
//                         keyboardType: TextInputType.number,
//                         controller: _groupLeadContact,
//                         decoration: InputDecoration(
//                           hintText: 'Group Contact Lead',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                       ),
//                     ),
//                     ListTile(
//                       leading: Icon(Icons.person, color: Colors.blue),
//                       title: TextField(
//                         controller: _groupLeadname,
//                         decoration: InputDecoration(
//                           hintText: 'Group Lead Name',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 50),
//                     Container(
//                       width: 150,
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           String pax = _pax.text;
//                           String travelerId = _travellerid.text;
//                           String groupLeadContact = _groupLeadContact.text;
//                           String groupLeadname = _groupLeadname.text;
//
//                           await saveTravelerIdToFirestore(
//                               travelerId, groupLeadContact);
//                           // Send WhatsApp message
//                           // String phoneNumber = groupLeadContact;
//                           // String message = "Your trip with traveler ID: $travelerId has been created.";
//                           //  sendSMSMessage(phoneNumber, message);
//                           //   sendWhatsAppMessage(phoneNumber, message);
//                           ScaffoldMessenger.of(context)
//                               .showSnackBar(const SnackBar(
//                             content: Text('Save Itenary Information>>'),
//                           ));
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => NewItenaryPage(),
//                             ),
//                           );
//                         },
//                         child: Row(
//                           children: [
//                             Text("Proceed"),
//                             Icon(
//                               Icons.arrow_forward_ios_outlined,
//                               color: Colors.grey,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
