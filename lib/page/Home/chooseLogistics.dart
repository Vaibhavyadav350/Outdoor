// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:outdoor_admin/page/Traveller/trid.dart';
// import 'package:outdoor_admin/routes.dart';
//
// import '../Driver/driveroute.dart';
// import '../Stays/StayManager.dart';
//
// class ChooseLogistics extends StatelessWidget {
//   const ChooseLogistics({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.white,
//       child: Center(
//         child: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Column(
//
//             children: [
//               const Text("Who are you...",style:TextStyle(fontSize: 40),),
//               const SizedBox(
//                 height: 30,
//               ),
//
//               GestureDetector(
//                 onTap: (){
//                    Navigator.popAndPushNamed(context, MyRoutes.travellers);
//
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//
//                         builder: (context) => StayManager()),
//                   );
//                 },
//                 child:
//                 Column(
//                   children: [
//                     Image.asset("assets/images/hotels.jpg",
//                       fit: BoxFit.cover,height: 150 ,),
//                     const Text("Hotel Manager",style:TextStyle(fontSize: 20),),
//
//                   ],
//
//                 ),
//                 // const Text("Traveller",style:TextStyle(fontSize: 20),),
//               ),
//
//               const SizedBox(
//                 height: 40,
//               ),
//
//               GestureDetector(
//                 onTap: (){
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       // Builder for the nextpage
//                       // class's constructor.
//                         builder: (context) => DriverRoute()),
//                   );
//                 },
//                 child:
//                 Column(
//                   children: [
//                     Image.asset("assets/images/driver.jpg",
//                       fit: BoxFit.cover,height: 150,),
//                     const Text("Driver",style:TextStyle(fontSize: 20),),
//                   ],
//                 ),
//                 // const Text("Traveller",style:TextStyle(fontSize: 20),),
//               ),
//               const SizedBox(
//                 height: 40,
//               ),
//
//               GestureDetector(
//                 onTap: (){
//                   Navigator.popAndPushNamed(context, MyRoutes.adminLogin);
//                 },
//                 child:
//                 Column(
//                   children: [
//                     Image.asset("assets/images/admin.jpg",
//                       fit: BoxFit.cover,height: 150,),
//                     const Text("Admin",style:TextStyle(fontSize: 20),),
//                   ],
//                 ),
//                 // const Text("Traveller",style:TextStyle(fontSize: 20),),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
