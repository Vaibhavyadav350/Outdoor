import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataFetcher {
  Future<Map<String, String?>> fetchCompanyNameAndPhone() async {
    final user = FirebaseAuth.instance.currentUser;

    String? fetchedCompanyName;
    String? fetchedPhone;

    if (user != null && user.phoneNumber != null) {
      final userPhone = user.phoneNumber!.substring(3);
      print('Fetching data for phone: $userPhone');

      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('admin').doc('hello').get();

      if (docSnapshot.exists) {
        final dataMap = docSnapshot.data() as Map<String, dynamic>?;
        final usersData = dataMap?['userstype'] as List<dynamic>? ?? [];

        for (var userData in usersData) {
          if (userData['phone'] == userPhone) {
            fetchedCompanyName = userData['company'] as String? ?? 'Unknown';
            fetchedPhone = userData['phone'] as String? ?? 'Unknown';
            break;
          }
        }
      }
    }

    return {
      'company': fetchedCompanyName,
      'phone': fetchedPhone,
    };
  }
}
