import 'package:firebase_auth/firebase_auth.dart';
import 'package:mob_project/models/models.dart';
import 'package:mob_project/repositories/repositories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  final UserRepository _userRepository = UserRepository();
  final BookingRepository _bookingRepository = BookingRepository();
  final TripRepository _tripRepository = TripRepository();

  /// Check if the current user's profile is complete
  /// Returns true if profile is complete, false if incomplete or user not found
  Future<bool> isProfileComplete() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return false;

      final user = await _userRepository.getUserById(currentUser.uid);
      if (user == null) return false;

      return user.isProfileComplete;
    } catch (e) {
      print('Error checking profile completeness: $e');
      return false;
    }
  }

  /// Load existing user data for the current user
  /// Returns UserModel if found, null otherwise
  Future<UserModel?> loadUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return null;

      return await _userRepository.getUserById(currentUser.uid);
    } catch (e) {
      print('Error loading user data: $e');
      return null;
    }
  }

  /// Complete user profile by creating or updating user document
  /// Returns true if successful, throws exception on error
  Future<bool> completeProfile({
    required String fullName,
    required String username,
    required String phoneNumber,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      // Check if user document exists
      final existingUser = await _userRepository.getUserById(currentUser.uid);
      final now = DateTime.now();

      if (existingUser == null) {
        // Create new user document
        final newUser = UserModel(
          userId: currentUser.uid,
          email: currentUser.email ?? '',
          fullName: fullName.trim(),
          username: username.trim(),
          phoneNumber: phoneNumber.trim(),
          createdAt: now,
          updatedAt: now,
        );
        await _userRepository.createUser(newUser);
      } else {
        // Update existing user document
        await _userRepository.updateUser(currentUser.uid, {
          'fullName': fullName.trim(),
          'username': username.trim(),
          'phoneNumber': phoneNumber.trim(),
        });
      }

      return true;
    } catch (e) {
      print('Error completing profile: $e');
      rethrow;
    }
  }

  /// Get the current Firebase Auth user's display name or email
  String? getCurrentUserDisplayInfo() {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.displayName ?? currentUser?.email;
  }

  /// Get the current Firebase Auth user's email
  String? getCurrentUserEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }

  /// Update user profile with new information
  /// Returns true if successful, throws exception on error
  Future<bool> updateProfile({
    required String fullName,
    required String username,
    required String phoneNumber,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      await _userRepository.updateUser(currentUser.uid, {
        'fullName': fullName.trim(),
        'username': username.trim(),
        'phoneNumber': phoneNumber.trim(),
      });

      return true;
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  /// Change user password
  /// Returns true if successful, throws exception on error
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      // Re-authenticate user with old password
      final credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: oldPassword,
      );

      await currentUser.reauthenticateWithCredential(credential);

      // Update password
      await currentUser.updatePassword(newPassword);

      return true;
    } catch (e) {
      print('Error changing password: $e');
      rethrow;
    }
  }

  /// Delete user account and all associated data
  /// This will:
  /// 1. Get all user's bookings
  /// 2. Return seats back to trips for confirmed bookings
  /// 3. Delete user's tickets
  /// 4. Delete user's bookings
  /// 5. Delete user's reviews
  /// 6. Delete user's support messages
  /// 7. Delete user's Firestore document
  /// 8. Delete user's Firebase Auth account
  /// Returns true if successful, throws exception on error
  Future<bool> deleteAccount() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      final userId = currentUser.uid;
      final firestore = FirebaseFirestore.instance;

      // 1. Get all user's bookings to return seats
      final bookings = await _bookingRepository.getUserBookings(userId);

      // 2. Return seats back to trips for confirmed bookings
      for (final booking in bookings) {
        if (booking.status == 'confirmed') {
          // Get the trip
          final trip = await _tripRepository.getTripById(booking.tripId);
          if (trip != null) {
            // Return the seats by adding them back to available seats
            await firestore.collection('trips').doc(booking.tripId).update({
              'availableSeats': FieldValue.increment(booking.numberOfGuests),
            });
          }
        }
      }

      // 3. Delete user's tickets
      final ticketsQuery = await firestore
          .collection('tickets')
          .where('userId', isEqualTo: userId)
          .get();
      for (final doc in ticketsQuery.docs) {
        await doc.reference.delete();
      }

      // 4. Delete user's bookings
      final bookingsQuery = await firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .get();
      for (final doc in bookingsQuery.docs) {
        await doc.reference.delete();
      }

      // 5. Delete user's reviews
      final reviewsQuery = await firestore
          .collection('reviews')
          .where('userId', isEqualTo: userId)
          .get();
      for (final doc in reviewsQuery.docs) {
        await doc.reference.delete();
      }

      // 6. Delete user's payments
      final paymentsQuery = await firestore
          .collection('payments')
          .where('userId', isEqualTo: userId)
          .get();
      for (final doc in paymentsQuery.docs) {
        await doc.reference.delete();
      }

      // 7. Delete user's support messages
      final supportQuery = await firestore
          .collection('support_messages')
          .where('userId', isEqualTo: userId)
          .get();
      for (final doc in supportQuery.docs) {
        await doc.reference.delete();
      }

      // 8. Delete user's Firestore document
      await _userRepository.deleteUser(userId);

      // 9. Delete user's Firebase Auth account
      await currentUser.delete();

      return true;
    } catch (e) {
      print('Error deleting account: $e');
      rethrow;
    }
  }
}
