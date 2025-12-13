# Backend Structure Documentation

## 📁 Folder Structure

```
lib/
├── config/
│   └── firebase_config.dart          # Firebase initialization & collection names
├── models/                            # Data models with static fields
│   ├── user_model.dart
│   ├── trip_model.dart
│   ├── booking_model.dart
│   ├── payment_model.dart
│   ├── ticket_model.dart
│   ├── support_message_model.dart
│   └── models.dart                    # Export all models
├── repositories/                      # Firebase CRUD operations
│   ├── user_repository.dart
│   ├── trip_repository.dart
│   ├── booking_repository.dart
│   ├── payment_repository.dart
│   ├── ticket_repository.dart
│   ├── support_repository.dart
│   └── repositories.dart              # Export all repositories
└── services/                          # Existing auth services
    ├── auth_service.dart
    └── google_sign_in_service.dart
```

## 🎯 How to Use

### 1. Import Models

```dart
import 'package:mob_project/models/models.dart';
```

### 2. Import Repositories

```dart
import 'package:mob_project/repositories/repositories.dart';
```

### 3. Use in Your Screens

#### Example: Get All Trips

```dart
final tripRepository = TripRepository();

// Get all trips
List<TripModel> trips = await tripRepository.getAllTrips();

// Or use Stream for real-time updates
Stream<List<TripModel>> tripsStream = tripRepository.streamTrips();
```

#### Example: Create Booking

```dart
final bookingRepository = BookingRepository();

final booking = BookingModel(
  bookingId: '', // Will be auto-generated
  userId: 'user123',
  tripId: 'trip456',
  bookingDate: DateTime.now(),
  selectedDate: DateTime(2025, 1, 15),
  selectedTime: '06:00 AM',
  numberOfGuests: 2,
  totalPrice: 398.0,
  serviceFee: 39.8,
  taxes: 19.9,
  finalTotal: 457.7,
  status: 'pending',
  paymentStatus: 'pending',
);

String bookingId = await bookingRepository.createBooking(booking);
```

#### Example: Get User Bookings

```dart
final bookingRepository = BookingRepository();
String userId = FirebaseAuth.instance.currentUser!.uid;

// Get all bookings
List<BookingModel> bookings = await bookingRepository.getUserBookings(userId);

// Or use Stream for real-time updates
Stream<List<BookingModel>> bookingsStream = bookingRepository.streamUserBookings(userId);
```

#### Example: Process Payment

```dart
final paymentRepository = PaymentRepository();
final bookingRepository = BookingRepository();
final ticketRepository = TicketRepository();

// Create payment
final payment = PaymentModel(
  paymentId: '',
  bookingId: bookingId,
  userId: userId,
  amount: 457.7,
  paymentMethod: 'card',
  cardNumber: '4242', // last 4 digits
  status: 'completed',
  paymentDate: DateTime.now(),
);

String paymentId = await paymentRepository.createPayment(payment);

// Update booking payment status
await bookingRepository.updatePaymentStatus(bookingId, 'paid');

// Create ticket
final ticket = TicketModel(
  ticketId: '',
  bookingId: bookingId,
  userId: userId,
  tripId: tripId,
  qrCode: 'QR_${bookingId}_${DateTime.now().millisecondsSinceEpoch}',
  status: 'active',
  createdAt: DateTime.now(),
);

String ticketId = await ticketRepository.createTicket(ticket);
```

## 📋 Model Fields (Static - No Dynamic Fields)

### UserModel

- userId: String
- email: String
- fullName: String
- phoneNumber: String?
- profileImageUrl: String?
- createdAt: DateTime
- updatedAt: DateTime

### TripModel

- tripId: String
- title: String
- destination: String
- description: String
- imageUrl: String
- departureDate: DateTime
- returnDate: DateTime
- duration: int
- price: double
- availableSeats: int
- maxCapacity: int
- status: String ('active' or 'cancelled')

### BookingModel

- bookingId: String
- userId: String
- tripId: String
- bookingDate: DateTime
- selectedDate: DateTime
- selectedTime: String
- numberOfGuests: int
- totalPrice: double
- serviceFee: double
- taxes: double
- finalTotal: double
- status: String ('pending', 'confirmed', 'cancelled')
- paymentStatus: String ('pending', 'paid')

### PaymentModel

- paymentId: String
- bookingId: String
- userId: String
- amount: double
- paymentMethod: String ('card', 'cash')
- cardNumber: String? (last 4 digits)
- status: String ('completed', 'failed')
- paymentDate: DateTime

### TicketModel

- ticketId: String
- bookingId: String
- userId: String
- tripId: String
- qrCode: String
- status: String ('active', 'used')
- createdAt: DateTime

### SupportMessageModel

- messageId: String
- userId: String
- name: String
- email: String
- subject: String
- message: String
- status: String ('open', 'resolved')
- createdAt: DateTime

## 🔥 Firebase Collections

All collection names are defined in `firebase_config.dart`:

```dart
FirebaseConfig.usersCollection           // 'users'
FirebaseConfig.tripsCollection           // 'trips'
FirebaseConfig.bookingsCollection        // 'bookings'
FirebaseConfig.paymentsCollection        // 'payments'
FirebaseConfig.ticketsCollection         // 'tickets'
FirebaseConfig.supportMessagesCollection // 'support_messages'
```

## ✅ Benefits

1. **Type Safety**: All fields are strongly typed
2. **No Dynamic Fields**: Prevents accidental field additions
3. **Easy to Use**: Simple CRUD operations through repositories
4. **Real-time Updates**: Stream support for live data
5. **Error Handling**: Try-catch blocks with meaningful error messages
6. **Validation**: Type checking prevents invalid data
7. **Clean Architecture**: Separation of models and data access logic

## 🚀 Next Steps

1. ✅ Models created with static fields
2. ✅ Repositories created with CRUD operations
3. ✅ Firebase initialized in main.dart
4. 📝 Now integrate repositories in your screens
5. 📝 Add data to Firebase collections manually or through admin panel
6. 📝 Test CRUD operations in your app
