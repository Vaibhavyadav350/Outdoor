import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outdoor_admin/page/Driver/DriverManager.dart';

import '../../routes.dart';

class DriverRoute extends StatelessWidget {
  const DriverRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            GestureDetector(
              onTap: (){
                  Navigator.of(context).push(
                MaterialPageRoute(
                builder: (context) => DriverManage()),
                );
              //  Navigator.popAndPushNamed(context, MyRoutes.driver);
              },
              child:
              Column(
                children: [
                  Image.asset("assets/images/myinfo.jpg",
                    fit: BoxFit.cover,height: 300,),
                  const Text("My Trips",style:TextStyle(fontSize: 20),),
                ],
              ),
              // const Text("Traveller",style:TextStyle(fontSize: 20),),
            ),

            const SizedBox(
              height: 20,
            ),

            GestureDetector(
              onTap: (){
                Navigator.popAndPushNamed(context, MyRoutes.vendors);
              },
              child:
              Column(
                children: [
                  Image.asset("assets/images/add.jpg",
                    fit: BoxFit.cover,height: 300,),
                  const Text("Add Me",style:TextStyle(fontSize: 20),),
                ],
              ),
              // const Text("Traveller",style:TextStyle(fontSize: 20),),
            ),
            const SizedBox(
              height: 20,
            ),

          ],
        ),
      ),
    );
  }
}
