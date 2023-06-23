import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:outdoor_admin/page/Iteanary/itenary.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class Pax extends StatefulWidget {
  const Pax({Key? key}) : super(key: key);

  @override
  State<Pax> createState() => _PaxState();
}

class _PaxState extends State<Pax> {
  late TextEditingController _pax;
  late TextEditingController _travellerid;
  late TextEditingController _groupLeadContact;
  String? fetchedFieldName;
  // //late TwilioFlutter twilioFlutter;
  // TwilioFlutter twilioFlutter = TwilioFlutter(
  // accountSid : 'AC475ab9b4d2f308d0fce82dc172cd2e98', // replace *** with Account SID
  // authToken : 'acbc742766a26762be167b87c94fc61f',  // replace xxx with Auth Token
  // twilioNumber : '+14155238886'  // replace .... with Twilio Number
  // );


  @override
  void initState() {
    super.initState();

    _pax = TextEditingController();
    _travellerid = TextEditingController();
    _groupLeadContact = TextEditingController();

    // Generate and set the initial value of traveler ID
    fetchComapnyname().then((_) {
      generateTravelerId().then((generatedId) {
        setState(() {
          _travellerid.text = generatedId;
        });
      });
    });

  }

  Future<void> fetchComapnyname() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (snapshot.exists) {
        String? phone = snapshot.data()?['phone'] as String?;
        if (phone != null) {
          QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('number').get();

          if (querySnapshot.docs.isNotEmpty) {
            for (QueryDocumentSnapshot<Map<String, dynamic>> document
            in querySnapshot.docs) {
              List<dynamic> phoneArray = document.data()['phone'];
              for (int i = 0; i < phoneArray.length; i++) {
                if (phoneArray[i] is Map<String, dynamic>) {
                  Map<String, dynamic> map =
                  Map<String, dynamic>.from(phoneArray[i]);
                  if (map.containsValue(phone)) {
                    fetchedFieldName = map.keys.first;
                    break;
                  }
                } else if (phoneArray[i] == phone) {
                  fetchedFieldName = 'phone';
                  break;
                }
              }
            }
          }
        }
      }
    }
  }

  Future<String> generateTravelerId() async {
    // Generate a unique traveler ID based on the numeric IDs stored in Firestore
    // You can customize this method according to your needs

    // Example: Get the latest traveler document from Firestore
    CollectionReference travelersCollection =
    FirebaseFirestore.instance.collection('travelers');
    QuerySnapshot querySnapshot = await travelersCollection
        .orderBy('numericId', descending: true)
        .limit(1)
        .get();

    int latestNumericId = 0;

    if (querySnapshot.docs.isNotEmpty) {
      latestNumericId = querySnapshot.docs.first.get('numericId') as int;
    }

    // Increment the latest numeric ID by 1 to generate a new traveler ID
    int newNumericId = latestNumericId + 1;

    return '$fetchedFieldName'+ '2023$newNumericId'; // Return the generated traveler ID
  }
  Future<void> saveTravelerIdToFirestore(String travelerId) async {
    CollectionReference travelersCollection =
    FirebaseFirestore.instance.collection('travelers');

    // Create a new document with the generated traveler ID
    await travelersCollection.add({
      'numericId': int.parse(travelerId.substring(9)), // Extract the numeric ID from the traveler ID
      // Add other fields as per your requirements
    });

    // twilioFlutter.sendWhatsApp(toNumber : '+919450188251',
    //     messageBody : 'hello world');
  }

  // void sendSMSMessage(String phoneNumber, String message) async {
  //   List<String> recipients = [phoneNumber];
  //   await sendSMS(message: message, recipients: recipients,sendDirect: true)
  //       .catchError((onError) {
  //     print(onError);
  //   });
  //
  //
  // }



  // void sendWhatsAppMessage(String phoneNumber, String message) async {
  //   String url = "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    const List<String> list1 = <String>['5 Seater', '7 Seater'];
    const List<String> list2 = <String>['1 Car', '2 Car', '3 Car', '4 Car'];
    String SeaterDropdown = list1.first;
    String CarNumbersDropdown = list2.first;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Traveller Details")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: ListView(
          children: [
            Column(
              children: [
                Column(
                  children: [
                    Image.asset(
                      "assets/images/pax.jpg",
                      fit: BoxFit.cover,
                      height: 200,
                    ),
                    ListTile(
                      leading: Icon(Icons.group_add, color: Colors.green),
                      title: TextField(
                        controller: _pax,
                        decoration: InputDecoration(
                          hintText: 'PAX',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(Icons.numbers, color: Colors.red),
                      title: TextField(
                        controller: _travellerid,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: 'Traveller ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(Icons.phone, color: Colors.blue),
                      title: TextField(
                        controller: _groupLeadContact,
                        decoration: InputDecoration(
                          hintText: 'Group Contact Lead',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Container(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () async {
                          String pax = _pax.text;
                          String travelerId = _travellerid.text;
                          String groupLeadContact = _groupLeadContact.text;
                          await saveTravelerIdToFirestore(travelerId);
                          // Send WhatsApp message
                          // String phoneNumber = groupLeadContact;
                          // String message = "Your trip with traveler ID: $travelerId has been created.";
                          //  sendSMSMessage(phoneNumber, message);
                       //   sendWhatsAppMessage(phoneNumber, message);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Save Itenary Information>>'),
                          )
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Itenary(
                                pax: pax,
                                travellerid: travelerId,
                                groupLeadContact: groupLeadContact,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Text("Proceed"),
                            Icon(Icons.arrow_forward_ios_outlined,color: Colors.grey,)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
