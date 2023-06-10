import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outdoor_admin/routes.dart';

import '../page/Iteanary/MainPage/collection.dart';
import '../page/Iteanary/pax.dart';
import '../page/Iteanary/MainPage/previousitenary.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}


class _AdminLoginState extends State<AdminLogin> {

  late TextEditingController username =TextEditingController();
  late TextEditingController password =TextEditingController();
  late String user ="Vishal";
  late String pass = "1234";
  void LoginAsAdmin(){

    if(username.text == user && password.text == pass){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
          Collections()
        ),
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Wrong Password'),
      )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 40),
            child: Column(
              children: [
                Image.asset("assets/images/admin.jpg",
                    fit: BoxFit.cover),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(height: 10,),
                TextFormField(
                  controller: username,
                  decoration: const InputDecoration(
                      hintText: "Enter Username",
                      labelText: "UserName"
                  ),
                  style: const TextStyle(
                      fontSize: 25
                  ),
                ),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  style: const TextStyle(
                      fontSize: 25
                  ),
                  decoration: const InputDecoration(
                      hintText: "Enter Password",
                      labelText: "Password"
                  ),
                ),
                SizedBox(height: 50,),
                ElevatedButton(
                    child: Text("Login"),
                    style:TextButton.styleFrom(minimumSize: Size(150,50)),
                    onPressed: () async {
                      LoginAsAdmin();
                      print("success");
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
