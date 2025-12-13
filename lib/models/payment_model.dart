import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final String paymentId;
  final String bookingId;
  final String userId;
  final double amount;
  final String paymentMethod; // 'card', 'cash'
  final String? cardNumber; // last 4 digits
  final String status; // 'completed', 'failed'
  final DateTime paymentDate;

  PaymentModel({
    required this.paymentId,
    required this.bookingId,
    required this.userId,
    required this.amount,
    required this.paymentMethod,
    this.cardNumber,
    required this.status,
    required this.paymentDate,
  });

  // Convert from Firestore document to PaymentModel
  factory PaymentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PaymentModel(
      paymentId: doc.id,
      bookingId: data['bookingId'] ?? '',
      userId: data['userId'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      paymentMethod: data['paymentMethod'] ?? 'card',
      cardNumber: data['cardNumber'],
      status: data['status'] ?? 'completed',
      paymentDate:
          (data['paymentDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert from Map to PaymentModel
  factory PaymentModel.fromMap(Map<String, dynamic> data, String id) {
    return PaymentModel(
      paymentId: id,
      bookingId: data['bookingId'] ?? '',
      userId: data['userId'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      paymentMethod: data['paymentMethod'] ?? 'card',
      cardNumber: data['cardNumber'],
      status: data['status'] ?? 'completed',
      paymentDate:
          (data['paymentDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert PaymentModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'cardNumber': cardNumber,
      'status': status,
      'paymentDate': Timestamp.fromDate(paymentDate),
    };
  }

  // Copy with method for updates
  PaymentModel copyWith({
    String? paymentId,
    String? bookingId,
    String? userId,
    double? amount,
    String? paymentMethod,
    String? cardNumber,
    String? status,
    DateTime? paymentDate,
  }) {
    return PaymentModel(
      paymentId: paymentId ?? this.paymentId,
      bookingId: bookingId ?? this.bookingId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      cardNumber: cardNumber ?? this.cardNumber,
      status: status ?? this.status,
      paymentDate: paymentDate ?? this.paymentDate,
    );
  }
}
