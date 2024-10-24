import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trade_loop/presentation/authentication/models/user_model.dart';

class UserRepository {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  Future<void> storeUser(UserModel user) async {
    try {
      assert(user.uid != null, 'User ID cannot be null.');
      final jsonMap = user.toJson();
      await _usersCollection.doc(user.uid).set(jsonMap);
    } catch (e) {
      print('Error storing user data: $e');
      rethrow;
    }
  }
}
