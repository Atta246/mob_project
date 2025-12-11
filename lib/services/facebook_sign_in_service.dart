import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FacebookSignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with Facebook
  Future<UserCredential?> signInWithFacebook() async {
    try {
      // Trigger the Facebook sign-in flow
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        // Get the access token
        final AccessToken accessToken = result.accessToken!;

        // Create a credential from the access token
        final OAuthCredential credential = FacebookAuthProvider.credential(
          accessToken.tokenString,
        );

        // Sign in to Firebase with the Facebook credential
        UserCredential userCredential = await _auth.signInWithCredential(
          credential,
        );

        // Check if this is a new user
        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          // Create user document in Firestore
          await _createUserDocument(userCredential.user!);
        }

        return userCredential;
      } else if (result.status == LoginStatus.cancelled) {
        // User cancelled the login
        print('Facebook login cancelled by user');
        return null;
      } else {
        // Login failed
        print('Facebook login failed: ${result.message}');
        throw Exception('Facebook login failed: ${result.message}');
      }
    } catch (e) {
      print('Error signing in with Facebook: $e');
      rethrow;
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'username': user.displayName ?? 'Facebook User',
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
        'provider': 'facebook',
        'photoUrl': user.photoURL,
      });
    } catch (e) {
      print('Error creating user document: $e');
      // Don't throw error, as authentication was successful
    }
  }

  // Sign out
  Future<void> signOut() async {
    await FacebookAuth.instance.logOut();
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
