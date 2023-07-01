import 'package:flutter/material.dart';

class TripDetails extends StatelessWidget {
  final String title;
  final String location;
  final int days;
  final String description;
  final List<String> photoUrls;

  const TripDetails({
    required this.title,
    required this.location,
    required this.days,
    required this.description,
    required this.photoUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              photoUrls.isNotEmpty ? photoUrls[0] : '',
              fit: BoxFit.cover,
              height: 200.0,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Text('Location: $location'),
                  Text('Days: $days'),
                  SizedBox(height: 10.0),
                  Text(
                    'Description:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Text(description),
                  SizedBox(height: 10.0),
                  Text(
                    'Photos:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: photoUrls.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(photoUrls[index], fit: BoxFit.cover);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
