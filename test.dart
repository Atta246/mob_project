import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'lib/firebase_options.dart';

void main() async {
  print('🔧 Starting Firebase Email Test...');

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');

    // Create a test user or get existing user
    final FirebaseAuth auth = FirebaseAuth.instance;
    final String testEmail = 'ahmedbod50@gmail.com';
    final String testPassword =
        'TestPassword123!'; // Temporary password for testing

    UserCredential? userCredential;

    try {
      // Try to sign in first (in case user already exists)
      userCredential = await auth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );
      print('✅ Signed in with existing user: ${userCredential.user?.uid}');
    } catch (e) {
      // If sign in fails, create new user
      print('ℹ️  User doesn\'t exist, creating new user...');
      userCredential = await auth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );
      print('✅ New user created: ${userCredential.user?.uid}');
    }

    final User? user = userCredential.user;

    if (user != null) {
      print('📧 Sending verification email to: $testEmail');

      // Send verification email
      await user.sendEmailVerification();

      print('✅ ✅ ✅ VERIFICATION EMAIL SENT SUCCESSFULLY! ✅ ✅ ✅');
      print('📬 Check your inbox at: $testEmail');
      print('📬 Also check your SPAM/JUNK folder!');
      print('');
      print('Email Details:');
      print('  - Email: ${user.email}');
      print('  - User ID: ${user.uid}');
      print('  - Email Verified: ${user.emailVerified}');
      print('  - Creation Time: ${user.metadata.creationTime}');

      // Sign out
      await auth.signOut();
      print('✅ Signed out successfully');
    } else {
      print('❌ No user found');
    }
  } catch (e, stackTrace) {
    print('❌ ERROR: $e');
    print('Stack Trace: $stackTrace');
  }

  print('');
  print('🏁 Test completed!');
}
