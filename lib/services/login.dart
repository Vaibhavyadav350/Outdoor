import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:outdoor_admin/services/auth.dart';

import '../routes.dart';

class Login extends StatefulWidget{
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context){
    return  Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32,horizontal: 10),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text("Login",style:TextStyle(color: Colors.blue,
                    fontWeight:FontWeight.bold,
                    fontSize: 40)),
                const SizedBox(
                  height: 20,
                ),
                Image.asset("assets/images/login.jpg",
                  fit: BoxFit.cover,height: 300),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                    child: Text("Login with Google"),
                    style:TextButton.styleFrom(minimumSize: Size(150,50)),
                    onPressed: () async {
                      AuthService.signWithGoogle();
                      print("success");
                    }
                ),
              ],
            ),
          ),
        )
    );
  }
}