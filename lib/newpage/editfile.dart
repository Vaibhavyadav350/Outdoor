import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'fetchitenarydetauls.dart';

class FormFields {
  String? _selectedLocation;
  String? _selectedDriver;
  String? _driverLicense;
  String? _driverPhone;
  String? _locationLicense;  // Add this
  String? _locationPhone;    // Add this
}

class EditItenaryPage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditItenaryPage({required this.data});

  @override
  _EditItenaryPageState createState() => _EditItenaryPageState();
}

class _EditItenaryPageState extends State<EditItenaryPage> {
  // Inherit most of the properties and methods from _NewItenaryPageState
  late String _selectedVendor;
  late DateTime initialDateofTrip;
  late DateTime finalDateofTrip;
  late int numberofLocations;
  late int numberofDrivers;
  List<FormFields> _formsListLocations = [];
  List<FormFields> _formsListDrivers = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> locations = [];
  List<String> vendors = [];
  List<String> vendortypes = [];
  List<String> vehicleTypes = [];
  String? _selectedDriver;
  var items = [1, 2, 3, 4, 5, 6];
  final _phoneController = TextEditingController();
  List<DocumentSnapshot> trips = [];
  String? fetchedFieldName;

  @override
  void initState() {
    super.initState();

    // Populate the form fields using widget.data
    _selectedVendor = widget.data['vendor'];
    initialDateofTrip = widget.data['initialDateofTrip']
        .toDate(); // Assuming it's stored as Timestamp in Firestore
    finalDateofTrip = widget.data['finalDateofTrip']
        .toDate(); // Assuming it's stored as Timestamp in Firestore
    numberofLocations = widget.data['locations'].length;

    // Populate _formsListLocations
    for (var location in widget.data['locations']) {
      _formsListLocations.add(FormFields()
        .._selectedLocation = location['name']
        .._locationLicense = location['license']
        .._locationPhone = location['phone']);
    }

    // Populate _formsListDrivers
    for (var driverDetail in widget.data['driversDetails']) {
      _formsListDrivers.add(FormFields()
        .._selectedDriver = driverDetail['name']
        .._driverLicense = driverDetail['license']
        .._driverPhone = driverDetail['phone']);
    }
    numberofDrivers = _formsListDrivers.length;

    // Call other initializations
    fetchLocations();
    fetchVehicleTypes(
        _selectedVendor); // Assuming _selectedVendor was defined previously in NewItenaryPage's state
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
        var locationName = doc['location'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Page"),
      ),
      body: Column(
        children: [
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
                    _selectedVendor = newValue!;
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
              onChanged: (String? newValue) {
                setState(() {
                  _formsListLocations[index]._selectedLocation = newValue;

                  // Optional: Fetch the other details (license & phone) for the selected location if needed
                });
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
        // Optionally display other details like _locationLicense & _locationPhone here
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
      String travellerId = widget.data['travellerid'];

      // Query the collection
      QuerySnapshot queryResult = await FirebaseFirestore.instance
          .collection('Itineraries')
          .where('travellerid', isEqualTo: travellerId)
          .get();

      if (queryResult.docs.isNotEmpty) {
        DocumentReference docRef = queryResult.docs.first.reference;

        // Create a map of the data you want to update
        Map<String, dynamic> updatedData = {
          'pax': widget.data['pax'],
          'travellerid': widget.data['travellerid'],
          'groupLeadContact': widget.data['groupLeadContact'],
          'groupLeadname': widget.data['groupLeadname'],
          'initialDateofTrip': initialDateofTrip,
          'finalDateofTrip': finalDateofTrip,
          'locations': _formsListLocations.map((f) => {
            'name': f._selectedLocation,
            'license': f._locationLicense,
            'phone': f._locationPhone
          }).toList(),
          'driversDetails': _formsListDrivers
              .map((f) => {
                    'name': f._selectedDriver,
                    'license': f._driverLicense,
                    'phone': f._driverPhone
                  })
              .toList(),
          'vendor': _selectedVendor,
          // Include other fields if any
        };

        // Update the document with the new data
        await docRef.update(updatedData);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Updated Successfully!')));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DisplayItineraryDetails(
                groupLeadContact: widget.data['groupLeadContact'])));
      } else {
        throw Exception('Document not found!');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred while updating!')));
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

      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('admin').doc('hello').get();

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
