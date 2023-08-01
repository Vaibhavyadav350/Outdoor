import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outdoor_admin/page/edit/editdriver.dart';
import 'package:outdoor_admin/page/edit/edittrips.dart';
import 'package:outdoor_admin/page/edit/postponed.dart';
import 'package:outdoor_admin/page/edit/preponed.dart';

import '../../noe_box.dart';
import 'editstays.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: GridView.count(

          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditTrips()),
                );
              },
              child: NeoBox(
                value: Column(

                  children: [
                    Icon(Icons.trip_origin_outlined,size: 100,color:Colors.green),
                    SizedBox(height: 10,),
                    const Text('Edit Travel Trips'),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Postpone()),
                );
              },
              child: NeoBox(
                value: Column(
                  children: [
                    Icon(Icons.date_range ,size: 100,color:Colors.green),
                    SizedBox(height: 10,),
                    const Text('Postpone Dates'),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Prepone()),
                );
              },
              child: NeoBox(
                value: Column(
                  children: [
                    Icon(Icons.date_range,size: 100,color:Colors.green),
                    SizedBox(height: 10,),
                    const Text('Prepone Dates'),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditStays()),
                );
              },
              child: NeoBox(
                value: Column(
                  children: [
                    Icon(Icons.home,size: 100,color:Colors.green),
                    SizedBox(height: 10,),
                    const Text('Change Stays'),
                  ],
                ),
              ),
            ),
                 GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => EditDriver()),
                    );
                  },
                  child: NeoBox(
                    value: Column(
                      children: [
                        Icon(Icons.drive_eta,size: 100,color:Colors.green),
                        SizedBox(height: 10,),
                        const Text('Change Driver'),
                      ],
                    ),
                  ),
                ),

            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditStays()),
                );
              },
              child: NeoBox(
                value: Column(
                  children: [
                    Icon(Icons.stadium,size: 100,color:Colors.green),
                    SizedBox(height: 10,),
                    const Text('Edit Stays Info'),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditDriver()),
                );
              },
              child: NeoBox(
                value: Column(
                  children: [
                    Icon(Icons.stacked_bar_chart,size: 100,color:Colors.green),
                    SizedBox(height: 10,),
                    const Text('Edit Driver Info'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
