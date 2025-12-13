import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/trip_model.dart';
import '../config/firebase_config.dart';

class TripRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all active trips
  Future<List<TripModel>> getAllTrips() async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseConfig.tripsCollection)
          .where('status', isEqualTo: 'active')
          .orderBy('departureDate')
          .get();

      return querySnapshot.docs
          .map((doc) => TripModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get trips: $e');
    }
  }

  // Stream all active trips (real-time updates)
  Stream<List<TripModel>> streamTrips() {
    return _firestore
        .collection(FirebaseConfig.tripsCollection)
        .where('status', isEqualTo: 'active')
        .orderBy('departureDate')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => TripModel.fromFirestore(doc)).toList(),
        );
  }

  // Get trip by ID
  Future<TripModel?> getTripById(String tripId) async {
    try {
      final doc = await _firestore
          .collection(FirebaseConfig.tripsCollection)
          .doc(tripId)
          .get();

      if (!doc.exists) return null;
      return TripModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get trip: $e');
    }
  }

  // Search trips by title or destination
  Future<List<TripModel>> searchTrips(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseConfig.tripsCollection)
          .where('status', isEqualTo: 'active')
          .get();

      // Filter results by title or destination
      return querySnapshot.docs
          .map((doc) => TripModel.fromFirestore(doc))
          .where(
            (trip) =>
                trip.title.toLowerCase().contains(query.toLowerCase()) ||
                trip.destination.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to search trips: $e');
    }
  }

  // Get trips by destination
  Future<List<TripModel>> getTripsByDestination(String destination) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseConfig.tripsCollection)
          .where('status', isEqualTo: 'active')
          .where('destination', isEqualTo: destination)
          .orderBy('departureDate')
          .get();

      return querySnapshot.docs
          .map((doc) => TripModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get trips by destination: $e');
    }
  }

  // Update trip available seats
  Future<void> updateAvailableSeats(String tripId, int seatsToReduce) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final tripRef = _firestore
            .collection(FirebaseConfig.tripsCollection)
            .doc(tripId);
        final tripDoc = await transaction.get(tripRef);

        if (!tripDoc.exists) {
          throw Exception('Trip not found');
        }

        final currentSeats = tripDoc.data()!['availableSeats'] as int;
        final newSeats = currentSeats - seatsToReduce;

        if (newSeats < 0) {
          throw Exception('Not enough available seats');
        }

        transaction.update(tripRef, {'availableSeats': newSeats});
      });
    } catch (e) {
      throw Exception('Failed to update seats: $e');
    }
  }

  // Restore seats (when booking is cancelled)
  Future<void> restoreSeats(String tripId, int seatsToRestore) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final tripRef = _firestore
            .collection(FirebaseConfig.tripsCollection)
            .doc(tripId);
        final tripDoc = await transaction.get(tripRef);

        if (!tripDoc.exists) {
          throw Exception('Trip not found');
        }

        final currentSeats = tripDoc.data()!['availableSeats'] as int;
        final maxCapacity = tripDoc.data()!['maxCapacity'] as int;
        final newSeats = currentSeats + seatsToRestore;

        if (newSeats > maxCapacity) {
          throw Exception('Seats exceed max capacity');
        }

        transaction.update(tripRef, {'availableSeats': newSeats});
      });
    } catch (e) {
      throw Exception('Failed to restore seats: $e');
    }
  }
}
