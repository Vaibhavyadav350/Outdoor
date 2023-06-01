import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outdoor_admin/page/Iteanary/futureitenary.dart';
import 'package:outdoor_admin/page/Iteanary/pax.dart';
import 'package:outdoor_admin/page/Iteanary/previousitenary.dart';
import '../../routes.dart';
import 'newcar.dart';
import 'ongoingItenary.dart';

class Collections extends StatefulWidget {
  const Collections({Key? key}) : super(key: key);

  @override
  State<Collections> createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {
  String previous = "Previous Trips";
  String OnGoing = "Ongoing Trips";
  String Later = "Future Trips";
  int _selecteditem =0;
  var pagesData = [PreviousItenary(),Ongoing(),FutureItenary()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: Drawer(

        child: ListView(

          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amberAccent,
              ),
              child: Column(
                children: [
                  Image.network(FirebaseAuth.instance.currentUser!.photoURL!,height: 100,width: 1000,),
                  SizedBox(height: 15,),
                  Text(FirebaseAuth.instance.currentUser!.displayName!),


                ],
              ),
            ),

            ListTile(
              leading: Icon(Icons.home,color: Colors.redAccent,),
              title: const Text('Add Stays'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pushNamed(context,MyRoutes.addStays);

              },
            ),
            ListTile(
              leading: Icon(Icons.perm_identity,color: Colors.redAccent,),
              title: const Text('Add Driver'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pushNamed(context,MyRoutes.vendors);
              },
            ),
            ListTile(
              leading: Icon(Icons.drive_eta_rounded,color: Colors.redAccent,),
              title: const Text('Add Cars'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => NewCar()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.people,color: Colors.redAccent,),
              title: const Text('Travellers'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pushNamed(context,MyRoutes.travellers);
              },
            ),
            ListTile(
              leading: Icon(Icons.done_all,color: Colors.redAccent,),
              title: const Text('Create Itenary'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => Pax()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('All Itenary'),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.access_time),label:previous),
        BottomNavigationBarItem(icon: Icon(Icons.car_rental),label:OnGoing,),
        BottomNavigationBarItem(icon: Icon(Icons.timer),label:Later),
      ],
        currentIndex: _selecteditem,
        onTap:(setValue){
          setState(() {
            _selecteditem =setValue;
          });
        } ,
      ),

      body: Center(
        child: pagesData[_selecteditem],
      ),
    );
  }
}
