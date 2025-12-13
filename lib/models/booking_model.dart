import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String bookingId;
  final String userId;
  final String tripId;
  final DateTime bookingDate;
  final DateTime selectedDate;
  final String selectedTime;
  final int numberOfGuests;
  final double totalPrice;
  final double serviceFee;
  final double taxes;
  final double finalTotal;
  final String status; // 'pending', 'confirmed', 'cancelled'
  final String paymentStatus; // 'pending', 'paid'

  BookingModel({
    required this.bookingId,
    required this.userId,
    required this.tripId,
    required this.bookingDate,
    required this.selectedDate,
    required this.selectedTime,
    required this.numberOfGuests,
    required this.totalPrice,
    required this.serviceFee,
    required this.taxes,
    required this.finalTotal,
    required this.status,
    required this.paymentStatus,
  });

  // Convert from Firestore document to BookingModel
  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      bookingId: doc.id,
      userId: data['userId'] ?? '',
      tripId: data['tripId'] ?? '',
      bookingDate:
          (data['bookingDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      selectedDate:
          (data['selectedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      selectedTime: data['selectedTime'] ?? '',
      numberOfGuests: data['numberOfGuests'] ?? 1,
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      serviceFee: (data['serviceFee'] ?? 0).toDouble(),
      taxes: (data['taxes'] ?? 0).toDouble(),
      finalTotal: (data['finalTotal'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      paymentStatus: data['paymentStatus'] ?? 'pending',
    );
  }

  // Convert from Map to BookingModel
  factory BookingModel.fromMap(Map<String, dynamic> data, String id) {
    return BookingModel(
      bookingId: id,
      userId: data['userId'] ?? '',
      tripId: data['tripId'] ?? '',
      bookingDate:
          (data['bookingDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      selectedDate:
          (data['selectedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      selectedTime: data['selectedTime'] ?? '',
      numberOfGuests: data['numberOfGuests'] ?? 1,
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      serviceFee: (data['serviceFee'] ?? 0).toDouble(),
      taxes: (data['taxes'] ?? 0).toDouble(),
      finalTotal: (data['finalTotal'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      paymentStatus: data['paymentStatus'] ?? 'pending',
    );
  }

  // Convert BookingModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'tripId': tripId,
      'bookingDate': Timestamp.fromDate(bookingDate),
      'selectedDate': Timestamp.fromDate(selectedDate),
      'selectedTime': selectedTime,
      'numberOfGuests': numberOfGuests,
      'totalPrice': totalPrice,
      'serviceFee': serviceFee,
      'taxes': taxes,
      'finalTotal': finalTotal,
      'status': status,
      'paymentStatus': paymentStatus,
    };
  }

  // Copy with method for updates
  BookingModel copyWith({
    String? bookingId,
    String? userId,
    String? tripId,
    DateTime? bookingDate,
    DateTime? selectedDate,
    String? selectedTime,
    int? numberOfGuests,
    double? totalPrice,
    double? serviceFee,
    double? taxes,
    double? finalTotal,
    String? status,
    String? paymentStatus,
  }) {
    return BookingModel(
      bookingId: bookingId ?? this.bookingId,
      userId: userId ?? this.userId,
      tripId: tripId ?? this.tripId,
      bookingDate: bookingDate ?? this.bookingDate,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      totalPrice: totalPrice ?? this.totalPrice,
      serviceFee: serviceFee ?? this.serviceFee,
      taxes: taxes ?? this.taxes,
      finalTotal: finalTotal ?? this.finalTotal,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }
}
