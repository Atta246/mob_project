import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/support_message_model.dart';
import '../config/firebase_config.dart';

class SupportRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new support message
  Future<String> createSupportMessage(SupportMessageModel message) async {
    try {
      final docRef = await _firestore
          .collection(FirebaseConfig.supportMessagesCollection)
          .add(message.toMap());

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create support message: $e');
    }
  }

  // Get support message by ID
  Future<SupportMessageModel?> getSupportMessageById(String messageId) async {
    try {
      final doc = await _firestore
          .collection(FirebaseConfig.supportMessagesCollection)
          .doc(messageId)
          .get();

      if (!doc.exists) return null;
      return SupportMessageModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get support message: $e');
    }
  }

  // Get all support messages for a user
  Future<List<SupportMessageModel>> getUserSupportMessages(
    String userId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseConfig.supportMessagesCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => SupportMessageModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user support messages: $e');
    }
  }

  // Stream user support messages (real-time updates)
  Stream<List<SupportMessageModel>> streamUserSupportMessages(String userId) {
    return _firestore
        .collection(FirebaseConfig.supportMessagesCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SupportMessageModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Update support message status
  Future<void> updateMessageStatus(String messageId, String status) async {
    try {
      await _firestore
          .collection(FirebaseConfig.supportMessagesCollection)
          .doc(messageId)
          .update({'status': status});
    } catch (e) {
      throw Exception('Failed to update message status: $e');
    }
  }

  // Get all open support messages
  Future<List<SupportMessageModel>> getOpenMessages() async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseConfig.supportMessagesCollection)
          .where('status', isEqualTo: 'open')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => SupportMessageModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get open messages: $e');
    }
  }

  // Delete support message
  Future<void> deleteSupportMessage(String messageId) async {
    try {
      await _firestore
          .collection(FirebaseConfig.supportMessagesCollection)
          .doc(messageId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete support message: $e');
    }
  }
}
