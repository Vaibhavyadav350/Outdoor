import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class FormFields {
  String? _selectedLocation;
  String? _selectedDriver;
  String? _driverLicense;
  String? _driverPhone;
  String? _hotelPhone;
  String? _hotelpluscode;
  String? _propertyManager;
}

class NewItenaryPage extends StatefulWidget {
  NewItenaryPage({
    Key? key,
  });

  @override
  State<NewItenaryPage> createState() => _NewItenaryPageState();
}

class _NewItenaryPageState extends State<NewItenaryPage> {
  String? _selectedVendor;
  final _formKey = GlobalKey<FormState>();
  DateTime initialDateofTrip = DateTime.now();
  DateTime finalDateofTrip = DateTime.now();
  int numberofLocations = 0;
  int numberofDrivers = 1;
  final _phoneController = TextEditingController();
  List<DocumentSnapshot> trips = [];
  String? fetchedFieldName;
  TextEditingController _pax = TextEditingController();
  TextEditingController _travellerid = TextEditingController();
  TextEditingController _groupLeadContact = TextEditingController();
  TextEditingController _groupLeadname = TextEditingController();
  TextEditingController pickupLocation = TextEditingController();
  TextEditingController dropLocation = TextEditingController();

  String mealplan = 'AMERICAN PLAN (AP)';
  var meals = [
    // Programming Languages
    'AMERICAN PLAN (AP)',
    'MODIFIED AMERICAN PLAN',
    'CONTINENTAL PLAN',
    'EUROPEAN PLAN'
  ];

  // List of items in our dropdown menu
  var items = [1, 2, 3, 4, 5, 6];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> locations = [];
  List<String> vendors = [];
  List<String> vendortypes = [];
  List<String> vehicleTypes = [];
  String? _selectedDriver;
  List<FormFields> _formsListLocations = [];
  List<FormFields> _formsListDrivers = [];

  @override
  void initState() {
    super.initState();
    fetchCompanyNameAndPhone();
    fetchLocations();
    for (int i = 0; i < numberofDrivers; i++) {
      _formsListDrivers.add(FormFields());
    }
    generateTravelerId().then((generatedId) {
      setState(() {
        _travellerid.text = generatedId;
      });
    });
  }

  Future<String> generateTravelerId() async {
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
    int newNumericId = latestNumericId + 1;
    return 'T2023$newNumericId';
  }

  Future<void> saveTravelerIdToFirestore(
      String travelerId, String groupLeadContact) async {
    String phoneValue = groupLeadContact;
    CollectionReference travelersCollection =
    FirebaseFirestore.instance.collection('travelers');

    int substringStartIndex = 5;
    int travelerIdLength = travelerId.length;

    if (substringStartIndex < travelerIdLength) {
      String numericIdString = travelerId.substring(substringStartIndex);
      int numericId = int.parse(numericIdString);

      QuerySnapshot snapshot = await travelersCollection
          .where('numericId', isEqualTo: numericId)
          .get();

      if (snapshot.docs.isEmpty) {
        await travelersCollection.add({
          'numericId': numericId,
          // Add other fields as per your requirements
        });
      } else {
        print('Document already exists with numericId: $numericId');
      }
    } else {
      print(
          'Substring start index is out of range for travelerId: $travelerId');
    }

    FirebaseFirestore.instance.collection('number').doc('Traveller').update({
      'phone': FieldValue.arrayUnion([phoneValue]),
      'num': FieldValue.arrayUnion([phoneValue])
    });
  }

  Future<void> fetchVehicleTypes(String vendorName) async {
    vehicleTypes.clear();
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Driver')
          .where('vendor', isEqualTo: vendorName)
          .get();

      for (var doc in snapshot.docs) {
        var vehicleType = doc['driver'];
        if (vehicleType != null && !vehicleTypes.contains(vehicleType)) {
          vehicleTypes.add(vehicleType);
        }
      }

      setState(() {}); // Refresh the UI after loading the vehicle types
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchLocations() async {
    try {
      QuerySnapshot stayssnapshot = await _firestore.collection('Stays').get();

      for (var doc in stayssnapshot.docs) {
        var locationName = doc['propertyName'];
        if (locationName != null) {
          locations.add(locationName);
        }
      }
      QuerySnapshot vendorsnapshot =
      await _firestore.collection('Driver').get();

      for (var doc in vendorsnapshot.docs) {
        var locationName = doc['vendor'];
        if (locationName != null) {
          vendors.add(locationName);
        }
      }

      setState(() {}); // Refresh the UI after loading the locations
    } catch (e) {
      print(e);
    }
  }

  void addForm() {
    _formsListLocations.add(FormFields());
    setState(() {});
  }

  void deleteForm(int index) {
    _formsListLocations.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Page"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.group_add, color: Colors.green),
              title: TextField(
                keyboardType: TextInputType.number,
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
                keyboardType: TextInputType.number,
                controller: _groupLeadContact,
                decoration: InputDecoration(
                  hintText: 'Group Contact Lead',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: TextField(
                controller: _groupLeadname,
                decoration: InputDecoration(
                  hintText: 'Group Lead Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: TextField(
                controller: pickupLocation,
                decoration: InputDecoration(
                  hintText: 'Enter Pickup Location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: TextField(
                controller: dropLocation,
                decoration: InputDecoration(
                  hintText: 'Enter Drop Location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  _showDateRangePicker(context);
                },
                child: Text("Pick date")),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: numberofLocations,
              itemBuilder: (context, index) {
                return locationform(index);
              },
            ),
            DropdownButton<String>(
              // Initial Value
              value: mealplan,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: meals.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),

              // After selecting the desired option, it will change button value to selected value
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    mealplan = newValue;
                  });
                }
              },
            ),
            DropdownButton(
              // Initial Value
              value: numberofDrivers,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: items.map((int items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text("$items"),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (int? newValue) {
                setState(() {
                  numberofDrivers = newValue!;
                  while (_formsListDrivers.length < numberofDrivers) {
                    _formsListDrivers.add(FormFields());
                  }
                  while (_formsListDrivers.length > numberofDrivers) {
                    _formsListDrivers.removeLast();
                  }
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Vendor"),
                SizedBox(
                  width: 40,
                ),
                DropdownButton<String>(
                  value: _selectedVendor,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedVendor = newValue;
                      _selectedDriver = null;
                    });
                    if (newValue != null) {
                      fetchVehicleTypes(newValue);
                    }
                  },
                  items: vendors.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: numberofDrivers,
              itemBuilder: (context, index) {
                return Driverform(index);
              },
            ),
            ElevatedButton(
              onPressed: saveToFirestore,
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  Widget locationform(int index) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Day $index Hotel"),
            SizedBox(
              width: 40,
            ),
            DropdownButton<String>(
              value: _formsListLocations[index]._selectedLocation,
              onChanged: (String? newValue) async {
                setState(() {
                  _formsListLocations[index]._selectedLocation = newValue;
                });
                if (newValue != null) {
                  // Fetch driver details
                  DocumentSnapshot driverDoc =
                  await _firestore.collection('Stays').doc(newValue).get();
                  if (driverDoc.exists) {
                    Map<String, dynamic> data =
                    driverDoc.data()! as Map<String, dynamic>;

                    _formsListLocations[index]._hotelPhone =
                    data['phoneNumber'];
                    _formsListLocations[index]._hotelpluscode =
                    data['location'];
                    _formsListLocations[index]._propertyManager =
                    data['managerName'];
                  }
                }
              },
              items: locations.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
          ],
        ),
      ],
    );
  }

  Widget Driverform(int index) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Driver"),
            SizedBox(
              width: 40,
            ),
            DropdownButton<String>(
              value: _formsListDrivers[index]._selectedDriver,
              onChanged: (String? newValue) async {
                setState(() {
                  _formsListDrivers[index]._selectedDriver = newValue;
                });
                if (newValue != null) {
                  // Fetch driver details
                  DocumentSnapshot driverDoc =
                  await _firestore.collection('Driver').doc(newValue).get();
                  if (driverDoc.exists) {
                    Map<String, dynamic> data =
                    driverDoc.data()! as Map<String, dynamic>;
                    print('Fetched Data: $data'); // Print fetched data
                    _formsListDrivers[index]._driverLicense = data['license'];
                    _formsListDrivers[index]._driverPhone = data['phone'];
                  }
                }
              },
              items: vehicleTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
          ],
        ),
      ],
    );
  }

  void saveToFirestore() async {
    try {
      // Create a reference to the collection where you want to store the data
      CollectionReference itineraries = _firestore.collection('Itineraries');
      saveTravelerIdToFirestore(_travellerid.text, _groupLeadContact.text);
      // Create a map of the data you want to save
      Map<String, dynamic> data = {
        'pax': _pax.text,
        'travellerid': _travellerid.text,
        'groupLeadContact': _groupLeadContact.text,
        'groupLeadname': _groupLeadname.text,
        'initialDateofTrip': initialDateofTrip,
        'finalDateofTrip': finalDateofTrip,
        'mealplan': mealplan,
        'locations': _formsListLocations
            .map((f) => {
          'PropertyName': f._selectedLocation,
          'PropertyManager': f._propertyManager,
          'Phonenumber': f._hotelPhone,
          'MapLocation': f._hotelpluscode
        })
            .toList(),
        'driversDetails': _formsListDrivers
            .map((f) => {
          'name': f._selectedDriver,
          'license': f._driverLicense,
          'phone': f._driverPhone
        })
            .toList(),
        'vendor': _selectedVendor,
        'company': fetchedFieldName
      };
      print(data);

      // Save the data to Firestore
      await itineraries.add(data);

      // Optionally, show a success message or perform other actions after saving
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Saved Successfully!')));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred while saving!')));
    }
  }

  //fuctions
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      DateTime? startDate = (args.value as PickerDateRange).startDate;
      DateTime? endDate = (args.value as PickerDateRange).endDate;

      if (startDate != null && endDate != null) {
        setState(() {
          initialDateofTrip = startDate;
          finalDateofTrip = endDate;
          numberofLocations =
              finalDateofTrip.difference(initialDateofTrip).inDays;
          // Ensure _formsListLocations is updated accordingly
          while (_formsListLocations.length < numberofLocations) {
            _formsListLocations.add(FormFields());
          }
          while (_formsListLocations.length > numberofLocations) {
            _formsListLocations.removeLast();
          }
        });
      }
    }
  }

  Future<void> fetchCompanyNameAndPhone() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.phoneNumber != null) {
      final userPhone = user.phoneNumber!.substring(3); // Removing country code

      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('admin')
          .doc('hello')
          .get();

      if (docSnapshot.exists) {
        final dataMap = docSnapshot.data() as Map<String, dynamic>?;
        final usersData = dataMap?['userstype'] as List<dynamic>? ?? [];

        for (var userData in usersData) {
          if (userData['phone'] == userPhone) {
            fetchedFieldName = userData['company'] as String? ?? 'Unknown';
            _phoneController.text = userData['phone'] as String? ?? 'Unknown';
            setState(() {});
            return;
          }
        }
      }
    }
  }

  void _showDateRangePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 400, // you can adjust the height as needed
            child: SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange:
              PickerDateRange(initialDateofTrip, finalDateofTrip),
              minDate: DateTime(2000),
              maxDate: DateTime(2100),
            ),
          );
        });
  }
}
