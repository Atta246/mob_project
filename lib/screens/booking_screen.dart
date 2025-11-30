import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mob_project/screens/payment_screen.dart';

class BookingPage extends StatefulWidget {
  final String tripId;

  const BookingPage({super.key, required this.tripId});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  int _numberOfGuests = 1;
  String _selectedTime = '06:00 AM';
  bool _isLoading = false;

  final List<String> _availableTimes = [
    '05:30 AM',
    '06:00 AM',
    '06:30 AM',
    '07:00 AM',
  ];

  // Mock trip data
  final Map<String, dynamic> _tripData = {
    'title': 'Cappadocia Adventure',
    'location': 'Cappadocia, Turkey',
    'price': 199.0,
    'duration': '1 hour',
    'maxGuests': 12,
  };

  double get _totalPrice => _tripData['price'] * _numberOfGuests;
  double get _serviceFee => _totalPrice * 0.1;
  double get _taxes => _totalPrice * 0.05;
  double get _finalTotal => _totalPrice + _serviceFee + _taxes;

  Future<void> _handleBooking() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate booking process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PaymentScreen()),
      );
    }
  }

  bool _isDateAvailable(DateTime date) {
    // Mock logic: dates in the future are available, weekends are not
    return date.isAfter(DateTime.now()) &&
        date.weekday != DateTime.saturday &&
        date.weekday != DateTime.sunday;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Your Trip'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Summary Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _tripData['title'],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.lightBlue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _tripData['location'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.lightBlue,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '\$${_tripData['price']}/person',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Date Selection
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Date',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: _focusedDate,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDate, day),
                      availableGestures: AvailableGestures.all,
                      calendarFormat: CalendarFormat.month,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                        weekendTextStyle: TextStyle(color: Colors.grey[400]),
                        disabledTextStyle: TextStyle(color: Colors.grey[400]),
                        selectedDecoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                      enabledDayPredicate: _isDateAvailable,
                      onDaySelected: (selectedDay, focusedDay) {
                        if (_isDateAvailable(selectedDay)) {
                          setState(() {
                            _selectedDate = selectedDay;
                            _focusedDate = focusedDay;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDate = focusedDay;
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Time Selection
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Time',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    children: _availableTimes.map((time) {
                      final isSelected = _selectedTime == time;
                      return ChoiceChip(
                        label: Text(time),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedTime = time;
                            });
                          }
                        },
                        selectedColor: Theme.of(context).primaryColor,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Number of Guests
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Number of Guests',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Guests',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'Max ${_tripData['maxGuests']} guests',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _numberOfGuests > 1
                                  ? () {
                                      setState(() {
                                        _numberOfGuests--;
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _numberOfGuests.toString(),
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              onPressed:
                                  _numberOfGuests < _tripData['maxGuests']
                                  ? () {
                                      setState(() {
                                        _numberOfGuests++;
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Price Breakdown
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price Breakdown',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPriceRow(
                    '\$${_tripData['price']} x $_numberOfGuests guests',
                    '\$${_totalPrice.toStringAsFixed(2)}',
                  ),
                  _buildPriceRow(
                    'Service fee',
                    '\$${_serviceFee.toStringAsFixed(2)}',
                  ),
                  _buildPriceRow('Taxes', '\$${_taxes.toStringAsFixed(2)}'),
                  const Divider(),
                  _buildPriceRow(
                    'Total',
                    '\$${_finalTotal.toStringAsFixed(2)}',
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleBooking,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('Book Now   \$${_finalTotal.toStringAsFixed(2)}'),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amount,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isTotal ? Theme.of(context).primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }
}
