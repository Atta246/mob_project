import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/firebase_config.dart';

class GenerateTestData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate all test data
  Future<void> generateAllTestData() async {
    print('🚀 Starting test data generation...');

    try {
      await generateTrips();
      print('✅ Trips data generated');

      // Only generate user-dependent data if user is logged in
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await generateUserData(currentUser.uid);
        print('✅ User data generated');

        await generateBookings(currentUser.uid);
        print('✅ Bookings data generated');
      } else {
        print('⚠️ No user logged in - skipping user-dependent data');
      }

      print('🎉 Test data generation complete!');
    } catch (e) {
      print('❌ Error generating test data: $e');
    }
  }

  // Generate Trips
  Future<void> generateTrips() async {
    final trips = [
      {
        'title': 'Classic Rainbow Balloon',
        'destination': 'Standard Flight',
        'description':
            'Enjoy a peaceful flight in our classic rainbow-colored hot air balloon. Perfect for families and first-time flyers.',
        'imageUrl':
        'https://d3rr2gvhjw0wwy.cloudfront.net/uploads/activity_galleries/135009/2000x2000-0-70-b8f41c97cd7fa7379c383e6fdf19629d.jpg',
        'departureDate': Timestamp.fromDate(
          DateTime.now().add(Duration(days: 7)),
        ),
        'returnDate': Timestamp.fromDate(
          DateTime.now().add(Duration(days: 7, hours: 2)),
        ),
        'duration': 120,
        'price': 150.0,
        'availableSeats': 12,
        'maxCapacity': 16,
        'status': 'active',
        'rating': 4.8,
        'reviewCount': 124,
        'maxAltitude': '2000 feet',
        'groupSize': '8-12 people',
        'highlights': [
          'Professional pilot and crew',
          'Safety briefing included',
          'Flight certificate',
          'Hotel pickup available',
          'Perfect for families',
        ],
      },
      {
        'title': 'Luxury Gold Balloon',
        'destination': 'Premium Experience',
        'description':
            'Experience luxury in our golden balloon with champagne service and premium comfort.',
        'imageUrl':
            'https://f6d3w8j9.rocketcdn.me/wp-content/uploads/2023/05/baloon1.jpeg',
        'departureDate': Timestamp.fromDate(
          DateTime.now().add(Duration(days: 10)),
        ),
        'returnDate': Timestamp.fromDate(
          DateTime.now().add(Duration(days: 10, hours: 2)),
        ),
        'duration': 120,
        'price': 250.0,
        'availableSeats': 8,
        'maxCapacity': 12,
        'status': 'active',
        'rating': 4.9,
        'reviewCount': 89,
        'maxAltitude': '3000 feet',
        'groupSize': '4-8 people',
        'highlights': [
          'Luxury hot air balloon flight',
          'Champagne celebration',
          'Premium breakfast',
          'Professional photography',
          'VIP hotel transfer',
        ],
      },
      {
        'title': 'Romantic Sunset Balloon',
        'destination': 'Evening Special',
        'description':
            'Perfect for couples! Enjoy a romantic evening flight with stunning sunset views.',
        'imageUrl':
            'https://cdn.getyourguide.com/img/tour/6447531509b14.jpeg/148.jpg',
        'departureDate': Timestamp.fromDate(
          DateTime.now().add(Duration(days: 14)),
        ),
        'returnDate': Timestamp.fromDate(
          DateTime.now().add(Duration(days: 14, hours: 2)),
        ),
        'duration': 120,
        'price': 200.0,
        'availableSeats': 10,
        'maxCapacity': 14,
        'status': 'active',
        'rating': 4.7,
        'reviewCount': 156,
        'maxAltitude': '2500 feet',
        'groupSize': '2-6 people',
        'highlights': [
          'Romantic sunset flight',
          'Sparkling wine included',
          'Private basket option',
          'Complimentary photos',
          'Perfect for proposals',
        ],
      },
      {
        'title': 'Adventure Sports Balloon',
        'destination': 'Thrill Seekers',
        'description':
            'For the adventurous! Higher altitude flights with extended duration.',
        'imageUrl':
            'https://sunrise-tours.co.uk/Images/uploads/Hot-Air-Balloon-Luxor1(1).png',
        'departureDate': Timestamp.fromDate(
          DateTime.now().add(Duration(days: 21)),
        ),
        'returnDate': Timestamp.fromDate(
          DateTime.now().add(Duration(days: 21, hours: 3)),
        ),
        'duration': 180,
        'price': 220.0,
        'availableSeats': 6,
        'maxCapacity': 10,
        'status': 'active',
        'rating': 4.9,
        'reviewCount': 73,
        'maxAltitude': '4000 feet',
        'groupSize': '4-8 people',
        'highlights': [
          'Extended flight time',
          'Maximum altitude experience',
          'GoPro camera rental',
          'Adventure certificate',
          'Expert pilot team',
        ],
      },
      {
        'title': 'Family Fun Balloon',
        'destination': 'Group Package',
        'description':
            'Special family package with kid-friendly activities and safety features.',
        'imageUrl':
            'https://res.klook.com/images/fl_lossy.progressive,q_65/c_fill,w_1295,h_862/w_80,x_15,y_15,g_south_west,l_Klook_water_br_trans_yhcmh3/activities/xoc0qkxcdrroprcipn5s/LuxurySunriseBalloonRideinLuxorwithHotelPickup.jpg',
        'departureDate': Timestamp.fromDate(
          DateTime.now().add(Duration(days: 5)),
        ),
        'returnDate': Timestamp.fromDate(
          DateTime.now().add(Duration(days: 5, hours: 2)),
        ),
        'duration': 120,
        'price': 175.0,
        'availableSeats': 14,
        'maxCapacity': 16,
        'status': 'active',
        'rating': 4.6,
        'reviewCount': 198,
        'maxAltitude': '1500 feet',
        'groupSize': '10-16 people',
        'highlights': [
          'Family-friendly experience',
          'Kids safety harnesses',
          'Light snacks included',
          'Group photo session',
          'Educational commentary',
        ],
      },
    ];

    for (var trip in trips) {
      await _firestore.collection(FirebaseConfig.tripsCollection).add(trip);
    }
  }

  // Generate User Data
  Future<void> generateUserData(String userId) async {
    final userData = {
      'email': FirebaseAuth.instance.currentUser?.email ?? 'test@example.com',
      'fullName': 'Ahmed Mohamed',
      'username': 'Ahmed',
      'phoneNumber': '+20 123 456 7890',
      'profileImageUrl': null,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    };

    await _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(userId)
        .set(userData, SetOptions(merge: true));
  }

  // Generate Bookings
  Future<void> generateBookings(String userId) async {
    // Get some trips first
    final tripsSnapshot = await _firestore
        .collection(FirebaseConfig.tripsCollection)
        .limit(2)
        .get();

    if (tripsSnapshot.docs.isEmpty) return;

    for (var tripDoc in tripsSnapshot.docs) {
      final tripData = tripDoc.data();
      final booking = {
        'userId': userId,
        'tripId': tripDoc.id,
        'bookingDate': Timestamp.now(),
        'selectedDate': tripData['departureDate'],
        'selectedTime': '06:00 AM',
        'numberOfGuests': 2,
        'totalPrice': (tripData['price'] ?? 150.0) * 2,
        'serviceFee': 10.0,
        'taxes': 15.0,
        'finalTotal': ((tripData['price'] ?? 150.0) * 2) + 10.0 + 15.0,
        'status': 'confirmed',
        'paymentStatus': 'paid',
      };

      final bookingRef = await _firestore
          .collection(FirebaseConfig.bookingsCollection)
          .add(booking);

      // Generate payment for this booking
      await generatePayment(
        userId,
        bookingRef.id,
        booking['finalTotal'] as double,
      );

      // Generate ticket for this booking
      await generateTicket(userId, bookingRef.id, tripDoc.id);
    }
  }

  // Generate Payment
  Future<void> generatePayment(
    String userId,
    String bookingId,
    double amount,
  ) async {
    final payment = {
      'bookingId': bookingId,
      'userId': userId,
      'amount': amount,
      'paymentMethod': 'card',
      'cardNumber': '4242',
      'status': 'completed',
      'paymentDate': Timestamp.now(),
    };

    await _firestore.collection(FirebaseConfig.paymentsCollection).add(payment);
  }

  // Generate Ticket
  Future<void> generateTicket(
    String userId,
    String bookingId,
    String tripId,
  ) async {
    final ticket = {
      'bookingId': bookingId,
      'userId': userId,
      'tripId': tripId,
      'qrCode': 'QR-${bookingId.substring(0, 8).toUpperCase()}',
      'status': 'active',
      'createdAt': Timestamp.now(),
    };

    await _firestore.collection(FirebaseConfig.ticketsCollection).add(ticket);
  }

  // Generate Support Messages
  Future<void> generateSupportMessages(String userId) async {
    final messages = [
      {
        'userId': userId,
        'name': 'Ahmed Mohamed',
        'email': FirebaseAuth.instance.currentUser?.email ?? 'test@example.com',
        'subject': 'Balloon Ride Question',
        'message':
            'Hi, I would like to know what should I bring for the balloon ride?',
        'status': 'open',
        'createdAt': Timestamp.now(),
      },
      {
        'userId': userId,
        'name': 'Ahmed Mohamed',
        'email': FirebaseAuth.instance.currentUser?.email ?? 'test@example.com',
        'subject': 'Booking Confirmation',
        'message': 'Can I get a confirmation email for my balloon booking?',
        'status': 'resolved',
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(Duration(days: 2)),
        ),
      },
    ];

    for (var message in messages) {
      await _firestore
          .collection(FirebaseConfig.supportMessagesCollection)
          .add(message);
    }
  }
}
