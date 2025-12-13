import 'package:cloud_firestore/cloud_firestore.dart';

class TripModel {
  final String tripId;
  final String title;
  final String destination;
  final String description;
  final String imageUrl;
  final DateTime departureDate;
  final DateTime returnDate;
  final int duration;
  final double price;
  final int availableSeats;
  final int maxCapacity;
  final String status; // 'active' or 'cancelled'
  final double rating;
  final int reviewCount;
  final String maxAltitude;
  final String groupSize;
  final List<String> highlights;

  TripModel({
    required this.tripId,
    required this.title,
    required this.destination,
    required this.description,
    required this.imageUrl,
    required this.departureDate,
    required this.returnDate,
    required this.duration,
    required this.price,
    required this.availableSeats,
    required this.maxCapacity,
    required this.status,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.maxAltitude = '',
    this.groupSize = '',
    this.highlights = const [],
  });

  // Convert from Firestore document to TripModel
  factory TripModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TripModel(
      tripId: doc.id,
      title: data['title'] ?? '',
      destination: data['destination'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      departureDate:
          (data['departureDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      returnDate:
          (data['returnDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      duration: data['duration'] ?? 0,
      price: (data['price'] ?? 0).toDouble(),
      availableSeats: data['availableSeats'] ?? 0,
      maxCapacity: data['maxCapacity'] ?? 0,
      status: data['status'] ?? 'active',
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      maxAltitude: data['maxAltitude'] ?? '',
      groupSize: data['groupSize'] ?? '',
      highlights: data['highlights'] != null
          ? List<String>.from(data['highlights'])
          : [],
    );
  }

  // Convert from Map to TripModel
  factory TripModel.fromMap(Map<String, dynamic> data, String id) {
    return TripModel(
      tripId: id,
      title: data['title'] ?? '',
      destination: data['destination'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      departureDate:
          (data['departureDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      returnDate:
          (data['returnDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      duration: data['duration'] ?? 0,
      price: (data['price'] ?? 0).toDouble(),
      availableSeats: data['availableSeats'] ?? 0,
      maxCapacity: data['maxCapacity'] ?? 0,
      status: data['status'] ?? 'active',
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      maxAltitude: data['maxAltitude'] ?? '',
      groupSize: data['groupSize'] ?? '',
      highlights: data['highlights'] != null
          ? List<String>.from(data['highlights'])
          : [],
    );
  }

  // Convert TripModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'destination': destination,
      'description': description,
      'imageUrl': imageUrl,
      'departureDate': Timestamp.fromDate(departureDate),
      'returnDate': Timestamp.fromDate(returnDate),
      'duration': duration,
      'price': price,
      'availableSeats': availableSeats,
      'maxCapacity': maxCapacity,
      'status': status,
      'rating': rating,
      'reviewCount': reviewCount,
      'maxAltitude': maxAltitude,
      'groupSize': groupSize,
      'highlights': highlights,
    };
  }

  // Copy with method for updates
  TripModel copyWith({
    String? tripId,
    String? title,
    String? destination,
    String? description,
    String? imageUrl,
    DateTime? departureDate,
    DateTime? returnDate,
    int? duration,
    double? price,
    int? availableSeats,
    int? maxCapacity,
    String? status,
    double? rating,
    int? reviewCount,
    String? maxAltitude,
    String? groupSize,
    List<String>? highlights,
  }) {
    return TripModel(
      tripId: tripId ?? this.tripId,
      title: title ?? this.title,
      destination: destination ?? this.destination,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      departureDate: departureDate ?? this.departureDate,
      returnDate: returnDate ?? this.returnDate,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      availableSeats: availableSeats ?? this.availableSeats,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      maxAltitude: maxAltitude ?? this.maxAltitude,
      groupSize: groupSize ?? this.groupSize,
      highlights: highlights ?? this.highlights,
    );
  }
}
