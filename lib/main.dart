import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:outdoor_admin/page/Iteanary/MainPage/previousitenary.dart';
import 'package:outdoor_admin/page/Iteanary/newvendor.dart';
import 'package:outdoor_admin/page/Iteanary/stay.dart';
import 'package:outdoor_admin/page/Iteanary/traveller.dart';
import 'package:outdoor_admin/page/Traveller/trid.dart';
import 'package:outdoor_admin/routes.dart';
import 'SplashScreen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      color: Colors.white,
        theme: ThemeData(
          primaryColor: Colors.indigoAccent,
          fontFamily: 'Roboto',
        ),
        home:SplashScreen(),
      //  initialRoute: "/wrapper",
        routes: {
          // MyRoutes.loginroute: (context) => Login(),
          MyRoutes.vendors: (context) => NewVendors(),
        //  MyRoutes.itenary:(context) => Itenary(),
        //   MyRoutes.wrapper:(context)=> Wrapper(),
          MyRoutes.addStays:(context)=> AddPropertyPage(),
          MyRoutes.travellers:(context)=> TravellerData(),
          MyRoutes.allitenary:(context) => PreviousItenary(),
       //  MyRoutes.travellerscreen:(context) => TravellerScreen("some"),
          MyRoutes.trid:(context)=> Travellerid()
        }
    );

  }
}