import 'package:flutter/material.dart';
import 'package:mob_project/screens/home/main_screen.dart';
import 'package:mob_project/widgets/widgets.dart';
import 'package:mob_project/models/models.dart';
import 'package:mob_project/repositories/repositories.dart';
import 'package:mob_project/screens/trips/ticket_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mob_project/utils/modern_snackbar.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  final BookingRepository _bookingRepository = BookingRepository();
  final TripRepository _tripRepository = TripRepository();
  final TicketRepository _ticketRepository = TicketRepository();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Trips'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.login, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text(
                'Please login to view your trips',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<List<BookingModel>>(
        stream: _bookingRepository.streamUserBookings(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          final bookings = snapshot.data ?? [];

          if (bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flight_takeoff, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'No trips yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start exploring and book your first trip!',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Column(
                children: bookings.map((booking) {
                  return FutureBuilder<TripModel?>(
                    future: _tripRepository.getTripById(booking.tripId),
                    builder: (context, tripSnapshot) {
                      if (!tripSnapshot.hasData) {
                        return const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        );
                      }

                      final trip = tripSnapshot.data!;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildBookingCard(context, booking, trip),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) {
            // Already on MyTrips
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => mainScreen(initialIndex: index),
              ),
              (route) => false,
            );
          }
        },
      ),
    );
  }

  Widget _buildBookingCard(
    BuildContext context,
    BookingModel booking,
    TripModel trip,
  ) {
    Color statusColor;
    String statusText;

    switch (booking.status) {
      case 'confirmed':
        statusColor = Colors.green;
        statusText = 'CONFIRMED';
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusText = 'PENDING';
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusText = 'CANCELLED';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'UNKNOWN';
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: trip.imageUrl.isNotEmpty
                ? Image.network(
                    trip.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/ballon.png',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    'assets/images/ballon.png',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Trip Title
                Text(
                  trip.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Location
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      trip.destination,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Booking Date
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${booking.selectedDate.month}/${booking.selectedDate.day}/${booking.selectedDate.year} at ${booking.selectedTime}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Number of Guests
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${booking.numberOfGuests} ${booking.numberOfGuests == 1 ? 'guest' : 'guests'}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Action Button
                if (booking.status == 'confirmed')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Get ticket for this booking
                        try {
                          final ticket = await _ticketRepository
                              .getTicketByBookingId(booking.bookingId);
                          if (ticket == null) {
                            throw Exception('Ticket not found');
                          }
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TicketScreen(
                                  bookingId: booking.bookingId,
                                  ticketId: ticket.ticketId,
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ModernSnackBar.show(
                              context,
                              'Error loading ticket: $e',
                              type: SnackBarType.error,
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'View Ticket',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                if (booking.status == 'pending')
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        ModernSnackBar.show(
                          context,
                          'Please complete payment to confirm booking',
                          type: SnackBarType.warning,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.orange),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Complete Payment'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
