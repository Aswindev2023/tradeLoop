import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trade_loop/presentation/profile/model/warning_message_model.dart';

class WarningServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<WarningMessageModel>> fetchWarnings(String userId) async {
    print('passed user id is $userId');
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('user_warnings')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();
      print('fetched warnings are : $querySnapshot');
      print(
          'QuerySnapshot docs: ${querySnapshot.docs.map((doc) => doc.data()).toList()}');

      return querySnapshot.docs.map((doc) {
        print(
            'returning these warnings : ${WarningMessageModel.fromSnapshot(doc).toString()}');
        return WarningMessageModel.fromSnapshot(doc);
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch warnings: $e");
    }
  }
}
