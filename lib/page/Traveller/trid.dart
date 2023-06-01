import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outdoor_admin/page/Traveller/travellerscreen.dart';
import 'package:outdoor_admin/routes.dart';

class Travellerid extends StatefulWidget {
  const Travellerid({Key? key}) : super(key: key);

  @override
  State<Travellerid> createState() => _TravelleridState();
}

class _TravelleridState extends State<Travellerid> {
  static late TextEditingController _travellid =TextEditingController();
  late TextEditingController _phonenumber =TextEditingController();
  late String passvalue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     body:
     Padding(
       padding: const EdgeInsets.all(30.0),
       child:
       SingleChildScrollView(
         physics: BouncingScrollPhysics(),
         child: Column(
              children: [
                Image.asset("assets/images/trv.jpg",
                  fit: BoxFit.cover,height: 400,),
                const Text("Traveller",style:TextStyle(fontSize: 20),),
                TextFormField(
                  controller: _travellid,
                  decoration: const InputDecoration(
                      hintText: "TravellerID",
                      labelText: "ID"
                  ),
                  style: const TextStyle(
                      fontSize: 25
                  ),
                  onChanged: (text){
                    passvalue = text;
                  },
                ),
                TextFormField(
                  controller: _phonenumber,
                  obscureText: true,
                  style: const TextStyle(
                      fontSize: 25
                  ),
                  decoration: const InputDecoration(
                      hintText: "Group Lead Phone",
                      labelText: "Phone Number"
                  ),
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                    child: Text("Go To Your Iteanry" ),

                    style:TextButton.styleFrom(minimumSize: Size(150,50)),
                  onPressed: () {
                    // Navigator to the next page.
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TravellerScreen( value : passvalue)),
                    );
                  },

                ),
              ],
    ),
       ),
     )
    );
  }
}
