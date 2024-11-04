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
      rethrow;
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(
      String uid, Map<String, dynamic> updatedFields) async {
    try {
      assert(uid.isNotEmpty, 'User ID cannot be empty.');
      await _usersCollection.doc(uid).update(updatedFields);
    } catch (e) {
      rethrow;
    }
  }
}
