import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../config/firebase_config.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new user
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore
          .collection(FirebaseConfig.usersCollection)
          .doc(user.userId)
          .set(user.toMap());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore
          .collection(FirebaseConfig.usersCollection)
          .doc(userId)
          .get();

      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Get user by email
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseConfig.usersCollection)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;
      return UserModel.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to get user by email: $e');
    }
  }

  // Update user
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = Timestamp.now();
      await _firestore
          .collection(FirebaseConfig.usersCollection)
          .doc(userId)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore
          .collection(FirebaseConfig.usersCollection)
          .doc(userId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // Stream user data (real-time updates)
  Stream<UserModel?> streamUser(String userId) {
    return _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return null;
          return UserModel.fromFirestore(doc);
        });
  }
}
