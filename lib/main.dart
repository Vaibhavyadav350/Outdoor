import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:outdoor_admin/page/Stays/StayManager.dart';
import 'package:outdoor_admin/page/phone.dart';
import 'package:outdoor_admin/services/adminlogin.dart';
import 'package:outdoor_admin/page/Home/choose.dart';
import 'package:outdoor_admin/page/Iteanary/previousitenary.dart';
import 'package:outdoor_admin/page/Iteanary/itenary.dart';
import 'package:outdoor_admin/page/Iteanary/newvendor.dart';
import 'package:outdoor_admin/page/Iteanary/stay.dart';
import 'package:outdoor_admin/page/Iteanary/traveller.dart';
import 'package:outdoor_admin/page/Traveller/travellerscreen.dart';
import 'package:outdoor_admin/page/Traveller/trid.dart';
import 'package:outdoor_admin/services/login.dart';
import 'package:outdoor_admin/page/wrapper.dart';
import 'package:outdoor_admin/routes.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      color: Colors.white,
        theme: ThemeData(primarySwatch: Colors.amber
        )
            .copyWith(textTheme: GoogleFonts.loraTextTheme())
        ,
        home: Wrapper(),
       // initialRoute: "/wrapper",
        routes: {
          MyRoutes.loginroute: (context) => Login(),
          MyRoutes.vendors: (context) => NewVendors(),
        //  MyRoutes.itenary:(context) => Itenary(),
          MyRoutes.wrapper:(context)=> Wrapper(),
          MyRoutes.addStays:(context)=> AddStays(),
          MyRoutes.travellers:(context)=> TravellerData(),
          MyRoutes.allitenary:(context) => PreviousItenary(),
          MyRoutes.adminLogin:(context) => AdminLogin(),
       //  MyRoutes.travellerscreen:(context) => TravellerScreen("some"),
          MyRoutes.trid:(context)=> Travellerid()
        }
    );

  }
}