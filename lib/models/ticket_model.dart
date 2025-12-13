import 'package:cloud_firestore/cloud_firestore.dart';

class TicketModel {
  final String ticketId;
  final String bookingId;
  final String userId;
  final String tripId;
  final String qrCode;
  final String status; // 'active', 'used'
  final DateTime createdAt;

  TicketModel({
    required this.ticketId,
    required this.bookingId,
    required this.userId,
    required this.tripId,
    required this.qrCode,
    required this.status,
    required this.createdAt,
  });

  // Convert from Firestore document to TicketModel
  factory TicketModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TicketModel(
      ticketId: doc.id,
      bookingId: data['bookingId'] ?? '',
      userId: data['userId'] ?? '',
      tripId: data['tripId'] ?? '',
      qrCode: data['qrCode'] ?? '',
      status: data['status'] ?? 'active',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert from Map to TicketModel
  factory TicketModel.fromMap(Map<String, dynamic> data, String id) {
    return TicketModel(
      ticketId: id,
      bookingId: data['bookingId'] ?? '',
      userId: data['userId'] ?? '',
      tripId: data['tripId'] ?? '',
      qrCode: data['qrCode'] ?? '',
      status: data['status'] ?? 'active',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert TicketModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'tripId': tripId,
      'qrCode': qrCode,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Copy with method for updates
  TicketModel copyWith({
    String? ticketId,
    String? bookingId,
    String? userId,
    String? tripId,
    String? qrCode,
    String? status,
    DateTime? createdAt,
  }) {
    return TicketModel(
      ticketId: ticketId ?? this.ticketId,
      bookingId: bookingId ?? this.bookingId,
      userId: userId ?? this.userId,
      tripId: tripId ?? this.tripId,
      qrCode: qrCode ?? this.qrCode,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
