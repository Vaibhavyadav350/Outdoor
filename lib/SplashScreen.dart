import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:outdoor_admin/page/wrapper.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  void navigateToNextScreen() async {
    // Add a delay of 2 seconds
    await Future.delayed(Duration(seconds: 3));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Wrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/trv.json'),
      ),
    );
  }
}
