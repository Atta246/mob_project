import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';
import '../config/firebase_config.dart';

class ReviewRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _reviewsCollection = 'reviews';

  // Create a new review
  Future<String> createReview(ReviewModel review) async {
    try {
      final docRef = await _firestore
          .collection(_reviewsCollection)
          .add(review.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create review: $e');
    }
  }

  // Get reviews for a specific trip
  Future<List<ReviewModel>> getReviewsByTripId(String tripId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_reviewsCollection)
          .where('tripId', isEqualTo: tripId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get reviews: $e');
    }
  }

  // Stream reviews for a specific trip (real-time updates)
  Stream<List<ReviewModel>> streamReviewsByTripId(String tripId) {
    return _firestore
        .collection(_reviewsCollection)
        .where('tripId', isEqualTo: tripId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReviewModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Calculate average rating for a trip
  Future<Map<String, dynamic>> getTripRatingStats(String tripId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_reviewsCollection)
          .where('tripId', isEqualTo: tripId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return {'rating': 0.0, 'count': 0};
      }

      double totalRating = 0;
      for (var doc in querySnapshot.docs) {
        totalRating += (doc.data()['rating'] ?? 0);
      }

      return {
        'rating': totalRating / querySnapshot.docs.length,
        'count': querySnapshot.docs.length,
      };
    } catch (e) {
      throw Exception('Failed to get rating stats: $e');
    }
  }

  // Update trip's rating and review count
  Future<void> updateTripRating(String tripId) async {
    try {
      final stats = await getTripRatingStats(tripId);
      await _firestore
          .collection(FirebaseConfig.tripsCollection)
          .doc(tripId)
          .update({'rating': stats['rating'], 'reviewCount': stats['count']});
    } catch (e) {
      throw Exception('Failed to update trip rating: $e');
    }
  }

  // Delete a review
  Future<void> deleteReview(String reviewId) async {
    try {
      await _firestore.collection(_reviewsCollection).doc(reviewId).delete();
    } catch (e) {
      throw Exception('Failed to delete review: $e');
    }
  }
}
