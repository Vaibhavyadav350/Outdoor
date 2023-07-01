import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:outdoor_admin/page/Iteanary/MainPage/collection.dart';

class TripInfo extends StatefulWidget {
  const TripInfo({Key? key}) : super(key: key);

  @override
  _TripInfoState createState() => _TripInfoState();
}

class _TripInfoState extends State<TripInfo> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _daysController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<File?> _selectedPhotos = [];

  Future<List<String>> _uploadPhotosToFirebase() async {
    List<String> photoUrls = [];

    for (var photo in _selectedPhotos) {
      if (photo != null) {
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('trip_photos')
            .child(DateTime.now().millisecondsSinceEpoch.toString());

        final UploadTask uploadTask = storageRef.putFile(photo);
        await uploadTask.whenComplete(() {});
        final photoUrl = await storageRef.getDownloadURL();
        photoUrls.add(photoUrl);
      }
    }
    return photoUrls;
  }

  void _saveToFirestore() async {
    List<String> photoUrls = await _uploadPhotosToFirebase();

    final tripData = {
      'title': _titleController.text,
      'location': _locationController.text,
      'days': int.parse(_daysController.text),
      'description': _descriptionController.text,
      'photoUrls': photoUrls,
    };

    await FirebaseFirestore.instance
        .collection('trips')
        .add(tripData)
        .then((documentRef) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trip information saved successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save trip information')),
      );
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Collections()),
    );
  }

  Future<void> _pickPhotosFromGallery() async {
    final picker = ImagePicker();

    List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _selectedPhotos = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _daysController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Information'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title',border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Location',border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),SizedBox(height: 10),
                TextFormField(
                  controller: _daysController,
                  decoration: InputDecoration(labelText: 'Number of Days',border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of days';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description',border: OutlineInputBorder()),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => _pickPhotosFromGallery(),
                  child: Text('Pick Photos'),
                ),
                SizedBox(height: 16.0),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: _selectedPhotos.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return _selectedPhotos[index] != null
                        ? Image.file(_selectedPhotos[index]!)
                        : Placeholder();
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveToFirestore();
                    }
                  },
                  child: Text('Save Trip Information'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
