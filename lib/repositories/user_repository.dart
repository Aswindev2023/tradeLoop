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

  Future<UserModel?> getUser(String uid) async {
    try {
      print('Fetching user with ID: $uid');
      final doc = await _usersCollection.doc(uid).get();
      if (doc.exists) {
        print('User data: ${doc.data()}');
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      print('User with UID $uid not found.');
      return null;
    } catch (e) {
      print('Error fetching user data: $e');
      rethrow;
    }
  }

  Future<void> updateUser(
      String uid, Map<String, dynamic> updatedFields) async {
    try {
      print('updating user with ID: $uid');
      assert(uid.isNotEmpty, 'User ID cannot be empty.');
      await _usersCollection.doc(uid).update(updatedFields);
      print('Updating user data in these fields:$updatedFields');
      print('updating fields value:${updatedFields.entries}');
    } catch (e) {
      print('Error updating user data: $e');
      rethrow;
    }
  }
}
