import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';
import '../config/firebase_config.dart';

class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new booking
  Future<String> createBooking(BookingModel booking) async {
    try {
      final docRef = await _firestore
          .collection(FirebaseConfig.bookingsCollection)
          .add(booking.toMap());

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  // Get booking by ID
  Future<BookingModel?> getBookingById(String bookingId) async {
    try {
      final doc = await _firestore
          .collection(FirebaseConfig.bookingsCollection)
          .doc(bookingId)
          .get();

      if (!doc.exists) return null;
      return BookingModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get booking: $e');
    }
  }

  // Get all bookings for a user
  Future<List<BookingModel>> getUserBookings(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseConfig.bookingsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('bookingDate', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user bookings: $e');
    }
  }

  // Stream user bookings (real-time updates)
  Stream<List<BookingModel>> streamUserBookings(String userId) {
    return _firestore
        .collection(FirebaseConfig.bookingsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('bookingDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BookingModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Get bookings by trip ID
  Future<List<BookingModel>> getTripBookings(String tripId) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseConfig.bookingsCollection)
          .where('tripId', isEqualTo: tripId)
          .orderBy('bookingDate', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get trip bookings: $e');
    }
  }

  // Update booking status
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _firestore
          .collection(FirebaseConfig.bookingsCollection)
          .doc(bookingId)
          .update({'status': status});
    } catch (e) {
      throw Exception('Failed to update booking status: $e');
    }
  }

  // Update payment status
  Future<void> updatePaymentStatus(
    String bookingId,
    String paymentStatus,
  ) async {
    try {
      await _firestore
          .collection(FirebaseConfig.bookingsCollection)
          .doc(bookingId)
          .update({
            'paymentStatus': paymentStatus,
            'status': paymentStatus == 'paid' ? 'confirmed' : 'pending',
          });
    } catch (e) {
      throw Exception('Failed to update payment status: $e');
    }
  }

  // Cancel booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _firestore
          .collection(FirebaseConfig.bookingsCollection)
          .doc(bookingId)
          .update({'status': 'cancelled'});
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  // Delete booking
  Future<void> deleteBooking(String bookingId) async {
    try {
      await _firestore
          .collection(FirebaseConfig.bookingsCollection)
          .doc(bookingId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete booking: $e');
    }
  }
}
