import 'package:cloud_firestore/cloud_firestore.dart';

class SupportMessageModel {
  final String messageId;
  final String userId;
  final String name;
  final String email;
  final String subject;
  final String message;
  final String status; // 'open', 'resolved'
  final DateTime createdAt;

  SupportMessageModel({
    required this.messageId,
    required this.userId,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.status,
    required this.createdAt,
  });

  // Convert from Firestore document to SupportMessageModel
  factory SupportMessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SupportMessageModel(
      messageId: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      subject: data['subject'] ?? '',
      message: data['message'] ?? '',
      status: data['status'] ?? 'open',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert from Map to SupportMessageModel
  factory SupportMessageModel.fromMap(Map<String, dynamic> data, String id) {
    return SupportMessageModel(
      messageId: id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      subject: data['subject'] ?? '',
      message: data['message'] ?? '',
      status: data['status'] ?? 'open',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert SupportMessageModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Copy with method for updates
  SupportMessageModel copyWith({
    String? messageId,
    String? userId,
    String? name,
    String? email,
    String? subject,
    String? message,
    String? status,
    DateTime? createdAt,
  }) {
    return SupportMessageModel(
      messageId: messageId ?? this.messageId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
