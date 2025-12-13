import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ticket_model.dart';
import '../config/firebase_config.dart';

class TicketRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new ticket
  Future<String> createTicket(TicketModel ticket) async {
    try {
      final docRef = await _firestore
          .collection(FirebaseConfig.ticketsCollection)
          .add(ticket.toMap());

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create ticket: $e');
    }
  }

  // Get ticket by ID
  Future<TicketModel?> getTicketById(String ticketId) async {
    try {
      final doc = await _firestore
          .collection(FirebaseConfig.ticketsCollection)
          .doc(ticketId)
          .get();

      if (!doc.exists) return null;
      return TicketModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get ticket: $e');
    }
  }

  // Get ticket by booking ID
  Future<TicketModel?> getTicketByBookingId(String bookingId) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseConfig.ticketsCollection)
          .where('bookingId', isEqualTo: bookingId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;
      return TicketModel.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to get ticket by booking: $e');
    }
  }

  // Get all tickets for a user
  Future<List<TicketModel>> getUserTickets(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseConfig.ticketsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => TicketModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user tickets: $e');
    }
  }

  // Stream user tickets (real-time updates)
  Stream<List<TicketModel>> streamUserTickets(String userId) {
    return _firestore
        .collection(FirebaseConfig.ticketsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TicketModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Update ticket status
  Future<void> updateTicketStatus(String ticketId, String status) async {
    try {
      await _firestore
          .collection(FirebaseConfig.ticketsCollection)
          .doc(ticketId)
          .update({'status': status});
    } catch (e) {
      throw Exception('Failed to update ticket status: $e');
    }
  }

  // Get ticket by QR code
  Future<TicketModel?> getTicketByQRCode(String qrCode) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseConfig.ticketsCollection)
          .where('qrCode', isEqualTo: qrCode)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;
      return TicketModel.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to get ticket by QR code: $e');
    }
  }
}
