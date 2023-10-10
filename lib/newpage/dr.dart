// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class DriverTripsPage extends StatefulWidget {
//   @override
//   _DriverTripsPageState createState() => _DriverTripsPageState();
// }
//
// class _DriverTripsPageState extends State<DriverTripsPage> {
//   final _phoneController = TextEditingController();
//   List<DocumentSnapshot> trips = [];
//   String? fetchedFieldName;
//
//   @override
//   void initState() {
//     super.initState();
//     initializeData();
//   }
//
//   Future<void> fetchCompanyNameAndPhone() async {
//     final user = FirebaseAuth.instance.currentUser;
//
//     if (user != null && user.phoneNumber != null) {
//       // Removing the country code from the user's phone number.
//       final userPhone = user.phoneNumber!.substring(3);
//       print('Fetching data for phone: $userPhone');
//
//       // Fetch the document named "hello" from the 'admin' collection.
//       DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('admin').doc('hello').get();
//
//       if (docSnapshot.exists) {
//         final dataMap = docSnapshot.data() as Map<String, dynamic>?;
//         final usersData = dataMap?['userstype'] as List<dynamic>? ?? [];
//
//         for (var userData in usersData) {
//           if (userData['phone'] == userPhone) {
//             fetchedFieldName = userData['company'] as String? ?? 'Unknown';
//             _phoneController.text = userData['phone'] as String? ?? 'Unknown';
//             print('Company: $fetchedFieldName');
//             print('Phone: ${_phoneController.text}');
//             setState(() {}); // Refresh UI with the new data.
//             return;
//           }
//         }
//         print('No matching phone number found in the userstype array');
//       } else {
//         print('Document "hello" does not exist in the admin collection');
//       }
//     } else {
//       print('User is not logged in or phone number is null');
//     }
//   }
//
//
//   Future<void> initializeData() async {
//     await fetchCompanyNameAndPhone();
//     _fetchTrips(_phoneController.text); // Fetch trips corresponding to the fetched phone number.
//   }
//
//   _fetchTrips(String phone) async {
//     if (phone.isNotEmpty) {
//       print('Fetching trips for phone: $phone');
//       // Fetch all itineraries
//       final tripDocs = await FirebaseFirestore.instance
//           .collection('Itineraries')
//           .get();
//
//       // Filter those that have the specific driver's phone in their driversDetails
//       final filteredTrips = tripDocs.docs.where((doc) {
//         final driversDetails = doc['driversDetails'] as List;
//         for (var driverDetail in driversDetails) {
//           if (driverDetail['phone'] == phone) {
//             return true;
//           }
//         }
//         return false;
//       }).toList();
//
//       setState(() {
//         trips = filteredTrips;
//       });
//       print('Number of trips found: ${trips.length}');
//     } else {
//       print('Phone is empty. Not fetching trips.');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Driver Trips")),
//       body: Column(
//         children: [
//
//           Expanded(
//             child: ListView.builder(
//               itemCount: trips.length,
//               itemBuilder: (context, index) {
//                 final trip = trips[index];
//                 DateTime initialDate = trip['initialDateofTrip'].toDate();
//                 DateTime finalDate = trip['finalDateofTrip'].toDate();
//                 return ListTile(
//                   title: Text('Trip ${index + 1}'),
//                   subtitle: Column(
//                     children: [
//                       Text(
//                           'From:  ${initialDate.toLocal()} \nTo:  ${finalDate.toLocal()} \nTeam Name  ${trip['groupLeadname']} \nLead Phone  ${trip['groupLeadContact']}'),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
