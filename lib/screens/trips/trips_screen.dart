import 'package:flutter/material.dart';
import 'package:mob_project/screens/trips/trip_details_screen.dart';
import 'package:mob_project/widgets/widgets.dart';
import 'package:mob_project/models/models.dart';
import 'package:mob_project/repositories/repositories.dart';

class tripsScreen extends StatefulWidget {
  const tripsScreen({super.key});

  @override
  State<tripsScreen> createState() => _tripsScreenState();
}

class _tripsScreenState extends State<tripsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final PageController _pageController = PageController(viewportFraction: 0.85);
  final TripRepository _tripRepository = TripRepository();

  List<TripModel> _trips = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    try {
      final trips = await _tripRepository.getAllTrips();
      setState(() {
        _trips = trips;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load trips: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB), // Sky blue at top
              Color(0xFFB8E6FF), // Light blue
              Color(0xFFE0F6FF), // Very light blue
              Color(0xFFF0F9FF), // Almost white blue
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Enhanced Header with floating balloons
              Container(
                height: MediaQuery.of(context).size.height * 0.825,
                child: Stack(
                  children: [
                    // Animated floating balloons

                    // Header content
                    Positioned.fill(
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Text(
                              "✈️ My Sky Adventures",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1E3A8A),
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                          // Logo with glow effect
                          //  const SizedBox(height: 15),
                          // Enhanced title
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Expanded(
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : _errorMessage != null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 60,
                                    color: Colors.white70,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    _errorMessage!,
                                    style: TextStyle(color: Colors.white70),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _loadTrips,
                                    child: Text('Retry'),
                                  ),
                                ],
                              ),
                            )
                          : _trips.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.flight_takeoff,
                                    size: 60,
                                    color: Colors.white70,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No trips available',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : PageView.builder(
                              controller: _pageController,
                              physics: const BouncingScrollPhysics(),
                              itemCount: _trips.length,
                              itemBuilder: (context, index) {
                                final trip = _trips[index];
                                final colors = [
                                  const Color(0xFFFFB347),
                                  const Color(0xFF87CEEB),
                                  const Color(0xFFDDA0DD),
                                ];
                                return EnhancedTripCard(
                                  imagePath: trip.imageUrl.isNotEmpty
                                      ? trip.imageUrl
                                      : 'assets/images/ballon.png',
                                  title: trip.title,
                                  subtitle: trip.description,
                                  date:
                                      "${trip.departureDate.month}/${trip.departureDate.day}/${trip.departureDate.year}",
                                  time:
                                      "${trip.departureDate.hour}:${trip.departureDate.minute.toString().padLeft(2, '0')}",
                                  price: trip.price.toStringAsFixed(0),
                                  status: trip.status == 'active'
                                      ? 'Upcoming'
                                      : 'Cancelled',
                                  color: colors[index % colors.length],
                                  onShowDetails: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TripDetailsPage(
                                          tripId: trip.tripId,
                                          trip: trip,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),

              // Enhanced Trip Cards with PageView
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // Enhanced bottom navigation
    );
  }
}
