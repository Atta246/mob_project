import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mob_project/models/models.dart';
import 'package:mob_project/repositories/repositories.dart';
import 'package:mob_project/utils/modern_snackbar.dart';

class TicketScreen extends StatefulWidget {
  final String bookingId;
  final String ticketId;

  const TicketScreen({
    super.key,
    required this.bookingId,
    required this.ticketId,
  });

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final TicketRepository _ticketRepository = TicketRepository();
  final BookingRepository _bookingRepository = BookingRepository();
  final TripRepository _tripRepository = TripRepository();

  TicketModel? _ticket;
  BookingModel? _booking;
  TripModel? _trip;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTicketData();
  }

  Future<void> _loadTicketData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load ticket
      final ticket = await _ticketRepository.getTicketById(widget.ticketId);

      // Load booking
      final booking = await _bookingRepository.getBookingById(widget.bookingId);

      if (booking == null) {
        throw Exception('Booking not found');
      }

      // Load trip
      final trip = await _tripRepository.getTripById(booking.tripId);

      setState(() {
        _ticket = ticket;
        _booking = booking;
        _trip = trip;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load ticket: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Your Ticket')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Your Ticket')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadTicketData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_ticket == null || _booking == null || _trip == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Your Ticket')),
        body: const Center(child: Text('Ticket not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Your Ticket'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
              ModernSnackBar.show(
                context,
                'Share functionality coming soon',
                type: SnackBarType.info,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Success Message
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green.shade700,
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking Confirmed!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your ticket has been generated',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Ticket Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header with Trip Image
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      image: DecorationImage(
                        image: _trip!.imageUrl.isNotEmpty
                            ? NetworkImage(_trip!.imageUrl)
                            : const AssetImage('assets/images/ballon.png')
                                  as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Trip Details
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _trip!.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _trip!.destination,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Booking Details
                        _buildDetailRow(
                          'Ticket ID',
                          _ticket!.ticketId.substring(0, 8),
                        ),
                        _buildDetailRow(
                          'Date',
                          '${_booking!.selectedDate.month}/${_booking!.selectedDate.day}/${_booking!.selectedDate.year}',
                        ),
                        _buildDetailRow('Time', _booking!.selectedTime),
                        _buildDetailRow(
                          'Guests',
                          '${_booking!.numberOfGuests}',
                        ),
                        _buildDetailRow(
                          'Status',
                          _ticket!.status.toUpperCase(),
                        ),

                        const SizedBox(height: 24),

                        // QR Code
                        Center(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: QrImageView(
                                  data: _ticket!.qrCode,
                                  version: QrVersions.auto,
                                  size: 200.0,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Scan this QR code at the venue',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Dashed Divider
                  CustomPaint(
                    size: const Size(double.infinity, 20),
                    painter: DashedLinePainter(),
                  ),

                  // Price Summary
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildPriceRow(
                          'Base Price',
                          '\$${_booking!.totalPrice.toStringAsFixed(2)}',
                        ),
                        _buildPriceRow(
                          'Service Fee',
                          '\$${_booking!.serviceFee.toStringAsFixed(2)}',
                        ),
                        _buildPriceRow(
                          'Taxes',
                          '\$${_booking!.taxes.toStringAsFixed(2)}',
                        ),
                        const Divider(height: 24),
                        _buildPriceRow(
                          'Total Paid',
                          '\$${_booking!.finalTotal.toStringAsFixed(2)}',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Download Ticket Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement download functionality
                  ModernSnackBar.show(
                    context,
                    'Download functionality coming soon',
                    type: SnackBarType.info,
                  );
                },
                icon: const Icon(Icons.download, color: Colors.white),
                label: const Text(
                  'Download Ticket',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Back to Home Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 5;
    const dashSpace = 5;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
