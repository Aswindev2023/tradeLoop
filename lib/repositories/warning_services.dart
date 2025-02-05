import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trade_loop/presentation/profile/model/warning_message_model.dart';

class WarningServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<WarningMessageModel>> fetchWarnings(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('user_warnings')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return WarningMessageModel.fromSnapshot(doc);
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch warnings: $e");
    }
  }
}
