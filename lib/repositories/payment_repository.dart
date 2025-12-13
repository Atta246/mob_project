import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_model.dart';
import '../config/firebase_config.dart';

class PaymentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new payment
  Future<String> createPayment(PaymentModel payment) async {
    try {
      final docRef = await _firestore
          .collection(FirebaseConfig.paymentsCollection)
          .add(payment.toMap());

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create payment: $e');
    }
  }

  // Get payment by ID
  Future<PaymentModel?> getPaymentById(String paymentId) async {
    try {
      final doc = await _firestore
          .collection(FirebaseConfig.paymentsCollection)
          .doc(paymentId)
          .get();

      if (!doc.exists) return null;
      return PaymentModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get payment: $e');
    }
  }

  // Get payment by booking ID
  Future<PaymentModel?> getPaymentByBookingId(String bookingId) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseConfig.paymentsCollection)
          .where('bookingId', isEqualTo: bookingId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;
      return PaymentModel.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to get payment by booking: $e');
    }
  }

  // Get all payments for a user
  Future<List<PaymentModel>> getUserPayments(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseConfig.paymentsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('paymentDate', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PaymentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user payments: $e');
    }
  }

  // Update payment status
  Future<void> updatePaymentStatus(String paymentId, String status) async {
    try {
      await _firestore
          .collection(FirebaseConfig.paymentsCollection)
          .doc(paymentId)
          .update({'status': status});
    } catch (e) {
      throw Exception('Failed to update payment status: $e');
    }
  }
}
